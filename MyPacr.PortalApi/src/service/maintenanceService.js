const directusService = require("../external/directusService");
var moment = require("moment");
const Promise = require("bluebird");

var handleCardMergeMaintenance = options => {
  //this method is meant to loop over all existing users and merge the transaactions of the inactive cards (by date and/or flag) into the active cards.
  //this method is mostly usefull for the implementation times of a new customer, where usually mistakes are made and double cards are made,etc...
  //NOTE: Only use this method the first year of implementation.

  return new Promise((resolve, reject) => {
    cardTypes = [];
    var startTime = new moment();
    nrOfAccounts = 0;

    directusService
      .getAllCardTypes()
      .then(resp => {
        cardTypes = resp;
        return directusService.getAllUsers();
      })
      .then(resp => {
        var payLoadRay = [];
        resp.forEach(element => {
          payLoadRay.push({
            user: element,
            options: options,
            cardTypes: cardTypes
          });
        });
        nrOfAccounts = payLoadRay.length;
        return Promise.mapSeries(payLoadRay, handleSingleUserCardMerge);
      })
      .then(() => {
        return resolve("All Users Handled for Card Merges");
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

var handleAttendanceMaintenances = options => {
  //this method is meant to loop over all existing users and repair the transactions for the attendence fees (stoeltjesgeld)
  //this should delete double stoeltjesgeld
  //this should delete transactions of attendence fees for cardtypes who are no supposed to have attendence fees
  //this should create refunds of transaction fees for days when an article was bought with a no_attendence_fee flag
  //this should create refunds of transaction fees for days when there were only articles bought with a 'doesnottriggerattendence' flag
  return new Promise((resolve, reject) => {
    var startTime = new moment();
    nrOfAccounts = 0;

    directusService
      .getAllUsers()
      .then(resp => {
        var payLoadRay = [];
        resp.forEach(element => {
          payLoadRay.push({
            user: element,
            options: options
          });
        });
        nrOfAccounts = payLoadRay.length;
        return Promise.mapSeries(payLoadRay, handleSingleUserAttendanceRepair);
      })
      .then(() => {
        return resolve("All Users handled for attendence fee fixes");
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

var handleInternalCardTransafers = options => {
  //this method is meant to loop over all existing users and do some internal transfers between cards of the same user, depending on the options
  return new Promise((resolve, reject) => {});
};

var handleOrderLineFix = options => {
  //this method is meant to loop over all orderlines and fix the issue where the order-link was missing
  return new Promise((resolve, reject) => {
    var startTime = new moment();

    directusService
      .getAllOrderItems()
      .then(resp => {
        return Promise.mapSeries(resp, handleSingleOrderLine);
      })
      .then(resp => {
        return resolve(resp);
      })
      .catch(err => {
        console.log(err);
        return reject(err);
      })
      .finally(() => {
        var endTime = new moment();
        var duration = moment.duration(endTime.diff(startTime));
        console.log(
          "Handled the orderlines fix Users, time: " +
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

var handleSingleOrderLine = orderline => {
  return new Promise((resolve, reject) => {
    if (!orderline.order) {
      directusService
        .getOrderByDate(orderline.created_on)
        .then(resp => {
          if (resp.length > 0) {
            return directusService.fixOrderItem(orderline.id, resp[0].id);
          } else {
            return resolve(resp);
          }
        })
        .then(resp => {
          console.log(resp);
          return resolve(resp);
        })
        .catch(err => {
          console.log(err);
          return reject(err);
        });
    } else {
      return resolve("order known");
    }
  });
};

var handleSingleUserCardMerge = payLoad => {
  var user = payLoad.user;
  var options = payLoad.options;
  var cardTypes = payLoad.cardTypes;

  console.log(
    "Starting Card Merge for user: " + user.first_name + " " + user.last_name
  );
  return new Promise((resolve, reject) => {
    //Get all cards for the user (including inactives)
    directusService
      .getAllCardLeasesByUserId(user.id)
      //loop over all cardTypes and get the cards from that Type From the user
      .then(resp => {
        //check if more than one card is set to be active or if cardType is meant to be excluded  --> if so, move to the next cardType
        cardTypes.forEach(element => {
          var ray = resp.filter(item => {
            return (
              item.card_leasing_type.id == element.id &&
              !options.excludeCardTypes.includes(element.id)
            );
          });
          var cardLeasings = ray;
          activecardLease = null;
          errorOccured = false;
          if (cardLeasings.length <= 1) {
            console.log(
              "Only 1 card of type: " + element.name + " -- no merges"
            );
            return resolve(null);
          }
          cardLeasings.forEach(cardLease => {
            if (cardLease.active) {
              if (activecardLease == null) {
                activecardLease = cardLease;
              } else {
                //multiple active Cards, can not Merge
                console.log(
                  "Multiple active cards of type: " +
                    element.name +
                    " -- no merges"
                );
                return resolve(null), (errorOccured = true);
              }
            }
          });
          if (activecardLease == null) {
            return resolve(null);
          } else {
            if (!errorOccured) {
              cardLeasings.forEach(step => {
                if (step.id != activecardLease.id) {
                  return directusService.doCardMerge(
                    step.id,
                    activecardLease.id,
                    parseFloat(step.saldo) + parseFloat(activecardLease.saldo)
                  );
                }
              });
            } else {
              return resolve(null);
            }
          }
        });
      })
      .then(resp => {
        console.log("Cards merged");
        return resolve(resp);
      })
      .catch(err => {
        console.log(err);
        return reject(err);
      });
  });
};

var handleSingleUserAttendanceRepair = payLoad => {
  var user = payLoad.user;
  var options = payLoad.options;
  console.log(
    "checking user :  " +
      user.id +
      "  -- " +
      user.first_name +
      " " +
      user.last_name
  );

  var cardLeases = [];

  return new Promise((resolve, reject) => {
    directusService.getAllCardLeasesByUserId(user.id).then(resp => {
      cardLeases = resp;
      if (cardLeases.length > 0) {
        return Promise.mapSeries(resp, element => {
          return new Promise((resolve, reject) => {
            console.log("checking for card: " + element.card.code);
            oldSaldo = element.saldo;

            saldochange = 0;

            transactionsToBeDeleted = [];
            transactionsToBeAdded = [];

            var dateHolder;

            if (element.card_leasing_type.no_attendence_fee) {
              theRay = element.transactions.filter(otem => {
                return otem.description == "stoeltjesgeld";
              });
              theRay.forEach(i => {
                console.log(
                  "found attendence fee for Attendenc-fee-free cardtype"
                );
                transactionsToBeDeleted.push(i.id);
                saldochange += i.amount;
              });
            } else {
              element.transactions.forEach(trans => {
                if (
                  trans.description == "stoeltjesgeld" &&
                  !moment(dateHolder).isSame(trans.time_of_transaction, "day")
                ) {
                  dateHolder = trans.time_of_transaction;

                  var transactionsToday = element.transactions.filter(
                    element2 => {
                      return moment(trans.time_of_transaction).isSame(
                        element2.time_of_transaction,
                        "day"
                      );
                    }
                  );

                  //check for doubles
                  var feeRay = transactionsToday.filter(element2 => {
                    return element2.description == "stoeltjesgeld";
                  });

                  //delete doubles
                  if (feeRay.length > 1) {
                    console.log("found double transactions");
                    transactionsToBeDeleted.push(feeRay[1].id);
                    saldochange += feeRay[1].amount;
                  }

                  //check if there was an articleboughtthatDay with a no_attendence

                  var articleRay = transactionsToday.filter(element2 => {
                    var articleBought = false;
                    if (element2.order != null) {
                      element2.order.order_items.forEach(t => {
                        if (t.article.no_attendence_fee) {
                          articleBought = true;
                        }
                      });
                    }
                    return articleBought;
                  });

                  var articleRayAttendenceRequired = transactionsToday.filter(
                    element2 => {
                      var articleBought = false;
                      if (element2.order != null) {
                        element2.order.order_items.forEach(t => {
                          if (!t.article.does_not_trigger_attendence) {
                            articleBought = true;
                          }
                        });
                      }
                      if (
                        element2.order != null &&
                        (element2.order.order_items == null ||
                          element2.order.order_items.length == 0)
                      ) {
                        articleBought = true;
                      }
                      if (
                        element2.order == null &&
                        element2.description == "bestelling kassa"
                      ) {
                        articleBought = true;
                      }
                      return articleBought;
                    }
                  );

                  var refundRay = transactionsToday.filter(element2 => {
                    return (
                      element2.description == "terugbetaling stoeltjesgeld"
                    );
                  });

                  var kassaRay = transactionsToday.filter(element2 => {
                    return element2.description == "bestelling kassa";
                  });

                  if (articleRay.length > 0 && refundRay.length == 0) {
                    console.log(
                      " found fee when no_attendence_fee article was bought"
                    );
                    transactionsToBeAdded.push({
                      top_off: true,
                      terminal: {
                        id: articleRay[0].terminal.id
                      },
                      amount: trans.amount,
                      cardleasing: {
                        id: element.id
                      },
                      description: "terugbetaling stoeltjesgeld",
                      no_vat: articleRay[0].no_vat,
                      new_saldo:
                        parseFloat(articleRay[0].new_saldo) +
                        parseFloat(trans.amount),
                      time_of_transaction: articleRay[0].time_of_transaction
                    });
                    saldochange += trans.amount;
                  }

                  if (
                    articleRayAttendenceRequired.length == 0 &&
                    kassaRay.length > 0 &&
                    refundRay.length == 0
                  ) {
                    console.log(
                      " found fee when there were only articles with doesnottriggerAttendence flags"
                    );
                    transactionsToBeAdded.push({
                      top_off: true,
                      terminal: {
                        id: trans.terminal.id
                      },
                      amount: trans.amount,
                      cardleasing: {
                        id: element.id
                      },
                      description: "terugbetaling stoeltjesgeld",
                      no_vat: trans.no_vat,
                      new_saldo:
                        parseFloat(trans.new_saldo) + parseFloat(trans.amount),
                      time_of_transaction: trans.time_of_transaction,
                      time_of_transaction_with_offset:
                        trans.time_of_transaction,
                      time_of_transaction_localized: customDateHandler.formatTimeAsTrueLocalTimeDateAndTime(
                        trans.time_of_transaction
                      )
                    });
                    saldochange += trans.amount;
                  }
                }
              });
            }
            if (transactionsToBeDeleted.length > 0) {
              console.log(
                "deleting " + transactionsToBeDeleted.length + " transactions"
              );
              directusService
                .deleteTransactions(transactionsToBeDeleted)
                .then(() => {
                  //done
                })
                .catch(err => {
                  console.log(err);
                });
            }

            if (transactionsToBeAdded.length > 0) {
              console.log(
                "adding " + transactionsToBeAdded.length + " transactions"
              );
              directusService
                .createTransactions(transactionsToBeAdded)
                .then(() => {})
                .catch(err => {
                  console.log(err);
                });
            }

            if (saldochange != 0) {
              var newSaldo = parseFloat(oldSaldo) + parseFloat(saldochange);
              console.log(
                "adjusting saldo to " + newSaldo + " from " + oldSaldo
              );
              return directusService
                .updateSaldo(element.id, newSaldo)
                .then(() => {
                  return resolve();
                })
                .catch(err => {
                  console.log(err);
                });
            }
            {
              return resolve(true);
            }
          })
            .then(resp => {
              //done
              return resolve(true);
            })
            .catch(err => {
              console.log(err);
              return reject(err);
            });
        });
      } else {
        return resolve(true);
      }
    });
  });
};

var handleSingleInternalCardTransfers = payLoad => {
  var user = payLoad.user;
  var options = payload.options;
  return new Promise((resolve, reject) => {
    //get All cards for the User
    //find the 'main' card of the user, if more then one are found --> abort
    //loop over the transactions of the cards and do the operations based on the options object
  });
};

var handleFillFullDescription = options => {
  return new Promise((resolve, reject) => {
    var startTime = new moment();
    nrOfAccounts = 0;

    directusService
      .getAllCardLeases()
      .then(resp => {
        var payLoadRay = [];
        resp.forEach(element => {
          payLoadRay.push({
            cardLease: element,
            options: options
          });
        });
        nrOfAccounts = payLoadRay.length;
        return Promise.mapSeries(payLoadRay, handleSingleFillFullDescription);
      })
      .then(() => {
        return resolve(
          "All Card Leases handled for filling the full description"
        );
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

var handleSingleFillFullDescription = payload => {
  var cardLease = payload.cardLease;
  var options = payload.options;

  return new Promise((resolve, reject) => {
    var fullDesc = "";
    var skip = false;

    if (cardLease.user == null) {
      skip = true;
      fullDesc += "NULL";
    } else {
      fullDesc += cardLease.user.first_name + " " + cardLease.user.last_name;
    }
    fullDesc += " - ";
    if (cardLease.card == null) {
      skip = true;
      fullDesc += "NULL";
    } else {
      fullDesc += cardLease.card.code;
    }

    fullDesc += " (";

    fullDesc += cardLease.card_leasing_type.name;

    fullDesc += " - ";

    if (cardLease.description == null) {
      fullDesc += " ";
    } else {
      fullDesc += cardLease.description;
    }

    fullDesc += ")";

    console.log(fullDesc);
    if (skip) {
      return resolve(true);
    } else {
      directusService
        .updateFullDescription(cardLease.id, fullDesc)
        .then(resp => {
          return resolve(true);
        })
        .catch(err => {
          console.log(err);
          return reject(err);
        });
    }
  });
};

module.exports = {
  handleAttendanceMaintenances,
  handleCardMergeMaintenance,
  handleInternalCardTransafers,
  handleOrderLineFix,
  handleFillFullDescription
};
