const nodeMailer = require("nodemailer");
const hbs = require("nodemailer-express-handlebars");
const Promise = require("bluebird");
const directusService = require("../external/directusService");
const config = require("config")

//TODO: this needs to be setup that all html messages are prepared before this service (removing the nodemailer-express-handlebar alltogether)
var getBareTransporter = () => {
  var mailConfig = config.get("mail")
  var transporter = nodeMailer.createTransport({
    host: mailConfig.host, 
    port: mailConfig.port, 
    auth: {
      user: mailConfig.user,
      pass: mailConfig.password 
    },
    tls: {
      ciphers: "SSLv3"
    },
    requireTLS: true
  });
  return transporter;
};

var getTransporter = () => {
  var mailConfig = config.get("mail")
  var transporter = nodeMailer.createTransport({
    host: mailConfig.host, 
    port: mailConfig.port,
    auth: {
      user: mailConfig.user,
      pass: mailConfig.password  
    },
    tls: {
      ciphers: "SSLv3"
    },
    requireTLS: true
  });

  transporter.use(
    "compile",
    hbs({
      viewEngine: {
        extName: ".handlebars",
        partialsDir: "./src/partials",
        layoutsDir: "./src/emailtemplates",
        defaultLayout: false
      },
      viewPath: "./src/emailtemplates"
    })
  );
  return transporter;
};

var sendPortalOrderMail = onlinePayment => {
  var context;
  return new Promise((resolve, reject) => {
    var transporter = getTransporter();
    directusService
      .getOnlinePaymentById(onlinePayment.id)
      .then(internalOnlinePayment => {
        var amount = 0;
        internalOnlinePayment.top_offs.forEach(element => {
          amount += parseFloat(element.amount);
          element.amount = element.amount.toFixed(2).replace(".", ",");
        });
        amount += parseFloat(generalSettings.handling_cost);
        context = internalOnlinePayment;
        context.Totaal = amount.toFixed(2).replace(".", ",");
        context.handling_fee = context.handling_fee
          .toFixed(2)
          .replace(".", ",");

        var mailOptions = {
          from: config.get("mail").from,
          to: context.coaccount.email,
          subject: "Bedankt voor uw aanvraag tot oplading",
          template: "PortalOrder",
          context: context
        };

        return transporter.sendMail(mailOptions);
      })
      .then(resp => {
        console.log("PortalOrder mail sent");
        return resolve(true);
      })
      .catch(err => {
        console.log(err);
        return reject(err);
      });
  });
};

var sendPaymentCompleteMail = onlinePayment => {
  var context;
  return new Promise((resolve, reject) => {
    var transporter = getTransporter();

    var amount = 0;
    onlinePayment.top_offs.forEach(element => {
      amount += parseFloat(element.amount);
      element.amount = element.amount.toFixed(2).replace(".", ",");
    });
    amount += parseFloat(generalSettings.handling_cost);
    context = onlinePayment;
    context.Totaal = amount.toFixed(2).replace(".", ",");
    context.handling_fee = context.handling_fee.toFixed(2).replace(".", ",");

    var mailOptions = {
      from: config.get("mail").from,
      to: context.coaccount.email,
      subject: "Bedankt voor uw betaling",
      template: "PortalPaymentComplete",
      context: context
    };

    transporter
      .sendMail(mailOptions)

      .then(resp => {
        console.log("PortalOrder mail sent");
        return resolve(true);
      })
      .catch(err => {
        console.log(err);
        return reject(err);
      });
  });
};

var sendMail = payLoad => {
  return new Promise((resolve, reject) => {
    var body = payLoad.msg;
    var email = payLoad.email;
    var title = payLoad.title;

    var transporter = getBareTransporter();

    var mailOptions = {
      from: config.get("mail").from,
      to: email,
      subject: title,
      html: body
    };

    transporter
      .sendMail(mailOptions)
      .then(resp => {
        console.log("Mail sent to " + (Array.isArray(email) ? email.join(', ') : email));
        return resolve(true);
      })
      .catch(err => {
        console.log(err);
        return reject(err);
      });
  });
};

var getEmailAdressListForUser = (userId, cardleasingId) => {
  return new Promise((resolve, reject) => {
    directusService
      .getCoAccountsForUserById(userId)
      .then(resp => {
        var emailList = [];
        if (cardleasingId) {
          resp.forEach(element => {
            element.users.forEach(innerElement => {
              if (innerElement.users_id.id == userId) {
                if (innerElement.users_id.selective_card_visibility) {
                  if (
                    element.allowed_card_leasings.some(x => {
                      return x.cardleasings_id.id == cardleasingId;
                    })
                  ) {
                    emailList.push(element.email);
                  }
                } else {
                  emailList.push(element.email);
                }
              }
            });
          });
        } else {
          resp.forEach(element => {
            emailList.push(element.email);
          });
        }
        console.log(emailList);
        return resolve(emailList);
      })
      .catch(err => {
        return reject(err);
      });
  });
};

module.exports = {
  sendPortalOrderMail,
  sendPaymentCompleteMail,
  sendMail,
  getEmailAdressListForUser
};
