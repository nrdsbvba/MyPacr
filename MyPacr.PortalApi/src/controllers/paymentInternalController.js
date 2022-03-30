const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");
const {
  createMollieClient
} = require("@mollie/api-client");
const directusService = require("../external/directusService");
const mailService = require('../service/mailService');
const config = require('config')
const customDateHandler = require('../logic/dates/customDateHandler');


const mollieClient = createMollieClient({
  apiKey: config.get('paymentProvider').apiKey
});

router.post("/generatePayment", (req, res) => {
  var auth = req.header("x-auth");
  //get parameters
  var coaccountEmail = req.body.email;
  var decoded = jwt.verify(auth, config.get('jwt').secret);

  var onlinePayment;
  var molliePayment;
  if (decoded.username != coaccountEmail) {
    res.status(401).send("UnAuthorized");
  } else {
    var coaccount_id = req.body.coaccount_id;
    var topOffs = req.body.topOffs
    var amount = 0
    topOffs.forEach(element => {
      amount += parseFloat(element.amount)
    });
    amount += parseFloat(generalSettings.handling_cost)

    let time = customDateHandler.getLocalTimeFormated()
    console.log('Time of payment:' +time)
    //create internal online payment
    let onlinePayment = {
      coaccount_id: coaccount_id,
      handling_fee: parseFloat(generalSettings.handling_cost),
      top_offs: topOffs,
      //todo add to directus
      time_of_payment: time,
      time_of_payment_with_offset: time,
      time_of_payment_localized: customDateHandler.formatTimeAsTrueLocalTimeDateAndTime(time),
    }
    directusService
      .createOnlinePayment(onlinePayment)
      .then(internalPayment => {
        console.log("temp: ")
        console.log(internalPayment)
        const portalSettings = config.get('portalSettings')
        onlinePayment = internalPayment

        var payload = {
          amount: {
            value: amount.toFixed(2),
            currency: "EUR"
          },
          description: "Oplading Athena kaart",
          redirectUrl: portalSettings.urlFront + "/#/betalingsuccess",
          webhookUrl: portalSettings.urlAPI + "/payment/webhook",
          metadata: {
            internalId: internalPayment.id
          }
        }
        console.log(payload)
        //then create mollie payment, using the id from the intenal payment
        return mollieClient.payments.create(payload);
      })
      .then(payment => {
        molliePayment = payment
        return mailService.sendPortalOrderMail(onlinePayment)
      })
      .then(() => {
        //after creation, pass down the url for the user to click
        res.json({
          url: molliePayment.getPaymentUrl()
        });
      })
      .catch(err => {
        console.log(err);
      });
  }
});

module.exports = router;