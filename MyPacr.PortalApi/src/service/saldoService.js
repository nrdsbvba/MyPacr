const moment = require("moment");
const Promise = require("bluebird");
const fs = require("fs");
const path = require("path");
const handlebars = require("handlebars");

const directusService = require("../external/directusService");
const smartschoolService = require("../external/smartschoolService");
const mailService = require("../service/mailService");

var handleLowBalanceChecks = options => {
  var saldoTreshold = global.generalSettings.low_balance_treshold;
  var startTime = new moment();
  nrOfAccounts = 0;

  var templateHtml = fs.readFileSync(
    path.join(
      process.cwd(),
      "/src/emailtemplates/BriefOntoereikendSaldo.handlebars"
    ),
    "utf8"
  );

  var template = handlebars.compile(templateHtml);

  return new Promise((resolve, reject) => {
    directusService
      .getCardLeasingsUnderTreshold(saldoTreshold)
      .then(resp => {
        var payloadRay = [];
        if (resp) {
          resp.forEach(element => {
            if (element.card_leasing_type.send_mail_when_balance_is_low) {
              var filterBool =
                new Date(element.from) < new Date() &&
                (new Date(element.till) > new Date() || element.till == null) &&
                element.active;

              if (filterBool) {
                  payloadRay.push({
                    cardleasing: element,
                    options: options,
                    template: template
                  });
              }
            }
          });
        }
        nrOfAccounts = payloadRay.length;
        return Promise.mapSeries(payloadRay, handleSingleLowBalance);
      })
      .then(() => {
        return resolve("All cardleasings Handled for Low BalanceChecks");
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
            " Users, time: " +
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

var handleSingleLowBalance = payload => {
  var cardleasing = payload.cardleasing;
  var options = payload.options;
  var template = payload.template;
  if (cardleasing.user) {
    console.log(
      "Handling Low Balance Control for user: " +
        cardleasing.user.first_name +
        " " +
        cardleasing.user.last_name
    );
  }

  return new Promise((resolve, reject) => {
    if (!cardleasing.user) {
      console.log("lege user op card leasing, kan geen bericht sturen");
      return resolve(true);
    }
    var data = {
      cardCode: cardleasing.card.code,
      saldo: "€ " + cardleasing.saldo.toFixed(2).replace(".", ","),
      user: cardleasing.user
    };
    var html = template(data);

    //check which provider to use
    var provider;

    var mailConfigs = global.Zconfigs.find(x => {
      return x.key == "messageProviderSettings";
    });

    if (mailConfigs) {
      provider = mailConfigs.config.find(x => {
        return x.message == "lowBalanceWarning";
      });
    }
    provider = provider
      ? provider
      : {
          message: "lowBalanceWarning",
          provider: "mail"
        };

    if (!cardleasing.user.selective_card_visibility) {
      //send msg to all co accounts for the given user
      if (provider.provider == "smartschool") {
        smartschoolService
          .sendMsgToAllCoAccounts({
            msg: html,
            username: cardleasing.user.smartschool_username,
            title: "Negatief Saldo"
          })
          .then(resp => {
            return resolve(true);
          })
          .catch(err => {
            console.log(err);
            return reject(err);
          });
      }
      if (provider.provider == "mail") {
        mailService
          .getEmailAdressListForUser(cardleasing.user.id)
          .then(emails => {
            return mailService.sendMail({
              msg: html,
              email: emails,
              title: "Negatief Saldo"
            });
          })
          .then(resp => {
            return resolve(true);
          })
          .catch(err => {
            console.log(err);
            return reject(err);
          });
      }
    } else {
      if (provider.provider == "smartschool") {
        smartschoolService
          .sendMsgToSelectiveCoAccounts({
            msg: html,
            username: cardleasing.user.smartschool_username,
            title: "Negatief Saldo",
            cardId: cardleasing.id
          })
          .then(resp => {
            return resolve(true);
          })
          .catch(err => {
            console.log(err);
            return reject(err);
          });
      }
      if (provider.provider == "mail") {
        mailService
          .getEmailAdressListForUser(cardleasing.user.id, cardleasing.id)
          .then(emails => {
            return mailService.sendMail({
              msg: html,
              email: emails,
              title: "Negatief Saldo"
            });
          })
          .then(resp => {
            return resolve(true);
          })
          .catch(err => {
            console.log(err);
            return reject(err);
          });
      }
    }
  });
};

module.exports = {
  handleLowBalanceChecks
};
