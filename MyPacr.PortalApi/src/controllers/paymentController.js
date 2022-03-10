const express = require("express");
const router = express.Router();
const passport = require("passport");
const jwt = require("jsonwebtoken");
const axios = require("axios");
const qs = require("qs");
const { createMollieClient } = require("@mollie/api-client");
const moment = require("moment");
const bodyParser = require("body-parser");

const userService = require("../service/userService");
const directusService = require("../external/directusService");
const mailService = require("../service/mailService");
const customDateHandler = require("../logic/dates/customDateHandler");
const config = require("config");

const Promise = require("bluebird");

const mollieClient = createMollieClient({
  apiKey: config.get("paymentProvider").apiKey,
});

router.post("/webhook", (req, res) => {
  var newSaldo;
  var card_leasing_id;
  var paymentMollie;
  var internalId;
  var errorOccured = false;

  var dossierskost = 0;
  var refunded = false;
  var internalonlinePayment;

  mollieClient.payments.get(req.body.id).then((payment) => {
    paymentMollie = payment;
    //get internal id
    internalId = payment.metadata.internalId;

    if (payment.isPaid()) {
      directusService
        .getOnlinePaymentById(internalId)
        .then((onlinePayment) => {
          internalonlinePayment = onlinePayment;
          if (onlinePayment.completed) {
            errorOccured = true;
            return null;
          } else {
            dossierskost = parseFloat(onlinePayment.handling_fee);
            return Promise.mapSeries(
              onlinePayment.top_offs,
              handleSingleCardTopOff
            );
          }
        })
        .then(() => {
          if (
            paymentMollie.method == "banktransfer" &&
            !internalonlinePayment.refunded &&
            !errorOccured
          ) {
            var amountObject = {
              value: internalonlinePayment.handling_fee.toFixed(2),
              currency: "EUR",
            };
            return mollieClient.payments_refunds.create({
              paymentId: req.body.id,
              amount: amountObject,
              description: "terugbetaling dossierskost Online Oplading",
            });
          } else {
            return null;
          }
        })
        .then((result) => {
          if (!errorOccured) {
            if (result == null) {
              return directusService.completeOnlinePayment(internalId, false);
            } else {
              return directusService.completeOnlinePayment(internalId, true);
            }
          } else {
            return null;
          }
        })
        .then((result) => {
          if (!errorOccured) {
            return mailService.sendPaymentCompleteMail(internalonlinePayment);
          } else {
            return null;
          }
        })
        .then((result) => {
          res.send(paymentMollie.status);
        })
        .catch((err) => {
          res.status(500).send(err);
          console.log(err);
        });
    }
  });
});

var handleSingleCardTopOff = (topOff) => {
  newSaldo = parseFloat(topOff.card_leasing.saldo) + parseFloat(topOff.amount);
  //next round is needed because of JS weirdness with floating numbers
  newSaldo = Math.round(newSaldo * 100) / 100;
  card_leasing_id = topOff.card_leasing.id;
  return new Promise((resolve, reject) => {
    //calculate new saldo

    let time = customDateHandler.getLocalTimeFormated();
    var theTransaction = {
      amount: parseFloat(topOff.amount),
      top_off: true,
      cardleasing: {
        id: topOff.card_leasing.id,
      },
      terminal: {
        id: 13, //online portal terminal --> nog sturing voorzien later
      },
      no_vat: true,
      description: "Oplading online Portaal",
      new_saldo: newSaldo,
      time_of_transaction: time,
      time_of_transaction_with_offset: time,
      time_of_transaction_localized: customDateHandler.formatTimeAsTrueLocalTimeDateAndTime(
        time
      ),
    };
    return directusService
      .createTransaction(theTransaction)
      .then((result) => {
        if (!result) {
          //fall through
          return null;
        } else {
          return directusService.updateSaldo(card_leasing_id, newSaldo);
        }
      })
      .then((result) => {
        if (!result) {
          //fall through
          return null;
        } else {
          return directusService.completeOnlineTopOff(topOff.id);
        }
      })
      .then((resp) => {
        return resolve(true);
      })
      .catch((err) => {
        console.log(err);
        return reject(err);
      });
  });
};

module.exports = router;
