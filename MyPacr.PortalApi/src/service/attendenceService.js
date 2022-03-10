const moment = require("moment");
const Promise = require("bluebird");
const fs = require("fs");
const path = require("path");
const handlebars = require("handlebars");

const mailService = require("../service/mailService");

const directusService = require("../external/directusService");
const smartschoolService = require("../external/smartschoolService");

var handleAttendences = options => {
  return new Promise((resolve, reject) => {
    var startTime = new moment();
    nrOfAccounts = 0;
    var currentDate = moment().format("YYYY-MM-DD");

    var attendenceExceptions = [];
    directusService
      .getAttendenceExceptionsForCurrentDay(currentDate)
      .then(resp => {
        attendenceExceptions = resp;
        var globalException = attendenceExceptions.some(element => {
          return element.global;
        });
        if (globalException) {
          console.log(
            "Global Exception found for current Date for Attendences"
          );
          return null;
        } else {
          //get all AttendenceProfiles
          return directusService.getAllAttendenceProfiles();
        }
      })
      .then(resp => {
        if (resp) {
          var payLoadRay = [];
          resp.forEach(element => {
            payLoadRay.push({
              profile: element,
              options: options,
              exceptions: attendenceExceptions
            });
          });
          nrOfAccounts = payLoadRay.length;
          return Promise.mapSeries(payLoadRay, handleSingleAttendenceProfile);
        } else {
          return null;
        }
      })
      .then(() => {
        return resolve("All Attendence Profiles handled");
      })
      .catch(err => {
        console.log(err);
        return reject(err);
      })
      .finally(() => {
        var endTime = new moment();
        var duration = moment.duration(endTime.diff(startTime));
        console.log(
          "Handled a total of " +
            nrOfAccounts +
            " AttendenceProfiles, time: " +
            duration.hours() +
            "h " +
            duration.minutes() +
            "m " +
            duration.seconds() +
            "s"
        );
      });
  });
};

var handleSingleAttendenceProfile = payload => {
  var profile = payload.profile;
  var options = payload.options;
  var exceptions = payload.exceptions;
  return new Promise((resolve, reject) => {
    //per attendenceProfile get Attendence for current Day and current User
    var currentDate = moment().format("YYYY-MM-DD");
    var currentDay = moment().isoWeekday();
    var currentDatePretty = moment().format("DD-MM-YYYY");
    var dayNames = [];

    if (profile.monday) {
      dayNames.push(1);
    }
    if (profile.tuesday) {
      dayNames.push(2);
    }
    if (profile.thursday) {
      dayNames.push(4);
    }
    if (profile.friday) {
      dayNames.push(5);
    }

    if (
      exceptions.some(element => {
        return element.user == profile.user.id;
      })
    ) {
      console.log(
        "Exception found for user attendence for user: " +
          profile.user.first_name +
          " " +
          profile.user.last_name
      );
      return resolve(true);
    } else {
      console.log(
        "Handling Attendence Control for user: " +
          profile.user.first_name +
          " " +
          profile.user.last_name
      );
    }
    return directusService
      .getAttendencesForUserByDate(profile.user.id, currentDate)
      .then(resp => {
        if (resp && resp.length >= 1) {
          console.log("user present Today");
          return resolve(true);
        } else {
          //check if user was supposed to have an attendence for that day
          if (
            dayNames.some(element => {
              return element == currentDay;
            })
          ) {
            //if there is no attendence while there was supposed to be one --> create absence
            return directusService.getAbsencesForUserByDate(
              profile.user.id,
              currentDate
            );
          } else {
            console.log("user should not be present based on profile");
          }
        }
        return null;
      })
      .then(resp => {
        if (resp && resp.length == 0) {
          return directusService.saveAbsence({
            user: { id: profile.user.id },
            date_of_absence: currentDate,
            handled: false
          });
        } else {
          return null;
        }
      })
      .then(resp => {
        if (resp) {
          var data = {
            datum: currentDatePretty,
            user: profile.user
          };

          var templateHtml = fs.readFileSync(
            path.join(
              process.cwd(),
              "/src/emailtemplates/BriefAfwezighedenSchoolRestaurant.handlebars"
            ),
            "utf8"
          );
          var template = handlebars.compile(templateHtml);
          var html = template(data);

          //check which provider to use
          var provider;

          var mailConfigs = global.Zconfigs.find(x => {
            return x.key == "messageProviderSettings";
          });

          if (mailConfigs) {
            provider = mailConfigs.config.find(x => {
              return x.message == "noAttendenceWarning";
            });
          }
          provider = provider
            ? provider
            : {
                message: "noAttendenceWarning",
                provider: "mail"
              };

          if (provider.provider == "smartschool") {
            //send msg to co accounts for the given user
            return smartschoolService.sendMsgToAllCoAccounts({
              msg: html,
              username: profile.user.smartschool_username,
              title: "Onvoorziene Afwezigheid"
            });
          }
          if (provider.provider == "mail") {
            mailService
              .getEmailAdressListForUser(profile.user.id)
              .then(emails => {
                return mailService.sendMail({
                  msg: html,
                  email: emails, //should be emails of coaccounts
                  title: "Onvoorziene Afwezigheid"
                });
              });
          }
        } else {
          return null;
        }
      })
      .then(resp => {
        return resolve(true);
      })
      .catch(err => {
        console.log(err);
        return reject(err);
      });
  });
};

module.exports = {
  handleAttendences
};
