import DirectusSDK from '@directus/sdk-js'
const Promise = require('bluebird')
const cronParser = require('cron-parser')
const customDateHandler = require('../logic/dates/customDateHandler')
const moment = require('moment')

const service = {
  settings: {
    url: process.env.directusApiUrl,
    projectUrl: '_',
    token: process.env.directusApiToken,
  }
}

var client = new DirectusSDK({
  url: service.settings.url,
  project: service.settings.projectUrl,
  storage: window.sessionStorage
})

service.isLoggedIn = (store) => {
  return store.state.loggedInInfo != null
}

service.login = (store, email, password) => {
  return new Promise((resolve, reject) => {
    client
      .login({
        email: email,
        password: password
      })
      .then(() => {
        return client.getMe({
          fields: '*,avatar.*'
        })
      })
      .then((resp) => {
        store.commit('setLoggedInInfo', resp.data)
        service.generateGlobalMasterKeyClient()
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getMe = (store) => {
  return new Promise((resolve, reject) => {
    client
      .getMe({
        fields: '*,avatar.*'
      })
      .then((resp) => {
        store.commit('setLoggedInInfo', resp.data)
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.generateGlobalMasterKeyClient = () => {
  client = new DirectusSDK({
    url: service.settings.url,
    project: service.settings.projectUrl,
    token: service.settings.token
  })
}

service.getThumbnail = (
  fileName,
  width,
  height,
  action = 'contain'
) => {
  var thumbNailLink =
    service.settings.url +
    '/_' +
    '/assets/' +
    fileName +
    '?w=' +
    width +
    '&' +
    'h=' +
    height +
    '&' +
    'f=' +
    action +
    '&q=80'

  return thumbNailLink
}

service.logOut = (store) => {
  store.commit('setLoggedInInfo', null)
}

service.getArticles = (store) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('articles', {
        fields: '*,picture.*, prices.*, categories.*.*, vat_level.*',
        filter: {
          active: {
            eq: 1
          }
        }
      })
      .then((resp) => {
        store.commit('setArticleList', resp.data)
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getUserCardByCardId = (
  store,
  cardId,
  attendeceFlag = false,
  commitAction = 'setCurrentCustomer'
) => {
  console.log(cardId)
  store.commit('setCurrentCustomerEntryFeePayedToday', null)
  store.commit('setCurrentCustomerEntryFeeRefunded', false)
  return new Promise((resolve, reject) => {
    client
      .getItems('cardleasings', {
        fields:
          '*, user.*, user.picture.*, user.campus.*, user.classgroup.*, user.usergroup.*.*.*, card.*, transactions.*, transactions.order.order_items.*.*, card_leasing_type.*, card_leasing_type.pricelevel.*',
        filter: {
          'card.code': {
            eq: cardId
          }
        }
      })
      .then((resp) => {
        //check through the card results and use the active card
        var activeCardLease = resp.data.find((element) => {
          var filterBool =
            new Date(element.from) < new Date() &&
            (new Date(element.till) > new Date() || element.till == null) &&
            element.active

          return filterBool
        })
        if (activeCardLease == null) {
          return resolve(null)
        }

        var action = commitAction

        store.commit(action, activeCardLease)
        if (activeCardLease && !attendeceFlag) {
          store.commit(
            'setActivePriceLevel',
            activeCardLease.card_leasing_type.pricelevel
          )
          store.commit('recalculateShoppingCart', true)
        }
        if (!attendeceFlag) {
          var usercard = activeCardLease
          var transactionsToday = usercard.transactions.filter((element) => {
            return moment().isSame(element.created_on, 'day')
          })
          var entry_fees_today = transactionsToday.filter((element) => {
            return element.description == 'stoeltjesgeld'
          })
          var refund_entry_fees_today = transactionsToday.filter((element) => {
            return element.description == 'terugbetaling stoeltjesgeld'
          })

          if (entry_fees_today.length > 0) {
            store.commit('setCurrentCustomerEntryFeePayedToday', {
              amount: entry_fees_today[0].amount
            })
          }
          if (refund_entry_fees_today.length > 0) {
            store.commit('setCurrentCustomerEntryFeeRefunded', true)
          }
        }
        return resolve(activeCardLease)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getCardForLinking = (store, cardId) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('cards', {
        fields: '*, card_leasings.*',
        filter: {
          code: {
            eq: cardId
          }
        }
      })
      .then((resp) => {
        var noCard = resp.data.length == 0
        store.commit('setCurrentCardForLinkUnkown', noCard)

        if (!noCard) {
          var activeCardLease = resp.data[0].card_leasings.find((element) => {
            var filterBool =
              new Date(element.from) < new Date() &&
              (new Date(element.till) > new Date() || element.till == null) &&
              element.active

            return filterBool
          })
          store.commit('setCurrentCardForLink', resp.data[0])
          if (activeCardLease != null) {
            store.commit('setCurrentCardForLinkInUse', true)
          } else {
            store.commit('setCurrentCardForLinkInUse', false)
          }
        } else {
          store.commit('setCurrentCardForLinkInUse', false)
          store.commit('setCurrentCardForLink', {
            code: cardId
          })
        }

        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getUserGroups = (store) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('usergroups', {
        fields: '*,pricelevel.*'
      })
      .then((resp) => {
        store.commit('setUserGroups', resp.data)
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getUserSuggestionsBySearchKey = (query) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('users', {
        fields: '*',
        filter: {
          first_name: {
            like: query
          },
          last_name: {
            logical: 'or',
            like: query
          }
        }
      })
      .then((resp) => {
        resp.data.forEach((element) => {
          element.fullName = element.first_name + ' ' + element.last_name
        })
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getCardSuggestionsBySearchKey = (query) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('cardleasings', {
        fields: '*,user.*,card.*',
        filter: {
          'user.first_name': {
            like: query
          },
          'user.last_name': {
            logical: 'or',
            like: query
          }
        }
      })
      .then((resp) => {
        var activeCardLeases = resp.data.filter((element) => {
          var filterBool =
            new Date(element.from) < new Date() &&
            (new Date(element.till) > new Date() || element.till == null) &&
            element.active

          return filterBool
        })
        activeCardLeases.forEach((element) => {
          element.fullName =
            element.user.first_name +
            ' ' +
            element.user.last_name +
            ' (' +
            element.card.code +
            ' - ' +
            element.description +
            ')'
        })
        return resolve(activeCardLeases)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getUserByIdForLink = (store, id) => {
  return new Promise((resolve, reject) => {
    client
      .getItem('users', id, {
        fields: '*, picture.*, campus.*, classgroup.*, usergroup.*.*.*'
      })
      .then((resp) => {
        store.commit('setCurrentCustomerForLink', resp.data)
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getGlobalSettings = (store) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('globalsettings', {
        fields: '*, default_pricelevel.*, '
      })
      .then((resp) => {
        store.commit('setGlobalSettings', resp.data[0])
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getTerminalOptions = (store) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('terminals', {
        fields: '*, terminalfunctions.*.*'
      })
      .then((resp) => {
        var unUsedTerminals = resp.data.filter((element) => {
          var filterBool =
            new Date(element.in_use_untill) < new Date() ||
            element.in_use_untill == null

          return filterBool
        })
        store.commit('setTerminalOptions', unUsedTerminals)
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.setTerminal = (terminal, uuid, date) => {
  return new Promise((resolve, reject) => {
    client
      .updateItem('terminals', terminal.id, {
        in_use_untill: date,
        cookielink: uuid
      })
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getTerminal = (store, uuid) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('terminals', {
        fields: '*, terminalfunctions.*.*, selectedevent.*.*',
        filter: {
          cookielink: {
            eq: uuid
          }
        }
      })
      .then((resp) => {
        store.commit('setCurrentTerminalInfo', resp.data[0])
        store.commit('setCurrentSelectedEvent', resp.data[0].selectedevent)
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.checkCurrentRoute = (store, route) => {
  var terminalfunctions = store.state.currentTerminalInfo.terminalfunctions
  if (route == '/kassa') {
    return (
      terminalfunctions.find((element) => {
        return element.terminalfunctions_id.functionname == 'Kassa'
      }) != null
    )
  }
  if (route == '/aanwezigheden') {
    return (
      terminalfunctions.find((element) => {
        return (
          element.terminalfunctions_id.functionname ==
          'AanwezighedenRegistratie'
        )
      }) != null
    )
  }
  if (route == '/kaartkoppelen') {
    return (
      terminalfunctions.find((element) => {
        return element.terminalfunctions_id.functionname == 'KaartKoppeling'
      }) != null
    )
  }
  if (route == '/registratie') {
    return (
      terminalfunctions.find((element) => {
        return element.terminalfunctions_id.functionname == 'RegistratieSysteem'
      }) != null
    )
  }
}

service.getRoute = (store) => {
  var terminalfunctions = store.state.currentTerminalInfo.terminalfunctions

  var kassaFunction = terminalfunctions.find((element) => {
    return element.terminalfunctions_id.functionname == 'Kassa'
  })
  if (kassaFunction != null) {
    return '/kassa'
  }
  var aanwezighedenFunction = terminalfunctions.find((element) => {
    return (
      element.terminalfunctions_id.functionname == 'AanwezighedenRegistratie'
    )
  })
  if (aanwezighedenFunction != null) {
    return '/aanwezigheden'
  }
  var kaartKoppelingFunction = terminalfunctions.find((element) => {
    return element.terminalfunctions_id.functionname == 'KaartKoppeling'
  })
  if (kaartKoppelingFunction != null) {
    return '/kaartkoppeling'
  }
}

service.completeOrder = (
  store,
  checkoutList,
  currentCustomer,
  returnMode = false
) => {
  var totalPrice = 0
  var orderLines = []
  var shouldTriggerAttendence = false
  var boughtArticleWithNoAttendenceFlag = false
  /*TODO: Need to implement VAT calculations here, based on:
vat_level for article
vat include in article
vat turned off for globalsettings
*/
  if (checkoutList != undefined) {
    checkoutList.forEach((element) => {
      //TODO: re-check pricelevels for current customer and articles --> double security
      totalPrice += parseFloat(element.cost)
      var addObject = {
        amount: element.number,
        article: {
          id: element.article.id
        },
        netto_total: parseFloat(element.cost),
        vat_total: 0
      }
      if (!element.article.does_not_trigger_attendence) {
        shouldTriggerAttendence = true
      }
      if (element.article.no_attendence_fee) {
        boughtArticleWithNoAttendenceFlag = true
      }
      orderLines.push(addObject)
    })
  }
  var usercard = currentCustomer
  var transactionsToday = usercard.transactions.filter((element) => {
    return moment().isSame(element.created_on, 'day')
  })
  var entry_fees_today = transactionsToday.filter((element) => {
    return element.description == 'stoeltjesgeld'
  })
  var refund_entry_fees_today = transactionsToday.filter((element) => {
    return element.description == 'terugbetaling stoeltjesgeld'
  })
  var transactionsTodayWithArticleAttendenceFee = transactionsToday.filter(
    (element) => {
      if (element.order != null) {
        var hasOne = false
        element.order.order_items.forEach((innerElement) => {
          if (innerElement.article.no_attendence_fee) {
            hasOne = true
          }
        })
        return hasOne
      } else {
        return false
      }
    }
  )

  var chargeEntryFee = true
  //als er geen entry fee is --> niet aanrekenen
  if (store.state.globalSettings.entry_fee <= 0) {
    chargeEntryFee = false
  }
  //als al betaald is --> niet aanrekenen
  if (entry_fees_today.length > 0) {
    chargeEntryFee = false
  }
  //als return after buy aanstaat en er vandaag reeds iets gekocht is --> niet aanrekenen
  if (
    store.state.globalSettings.entry_fee_return_after_buy &&
    transactionsToday.length > 0
  ) {
    chargeEntryFee = false
  }
  if (usercard.card_leasing_type.no_attendence_fee) {
    chargeEntryFee = false
  }
  if (boughtArticleWithNoAttendenceFlag) {
    chargeEntryFee = false
  }
  if (transactionsTodayWithArticleAttendenceFee.length > 0) {
    chargeEntryFee = false
  }

  if (store.state.salesMode) {
    chargeEntryFee = false
    shouldTriggerAttendence = false
  }

  var newSaldo = returnMode
    ? parseFloat(currentCustomer.saldo) + parseFloat(totalPrice)
    : parseFloat(currentCustomer.saldo) - parseFloat(totalPrice)

  var newSaldo2 =
    parseFloat(newSaldo) - parseFloat(store.state.globalSettings.entry_fee)

  var newSaldo3
  if (store.state.currentCustomerEntryFeePayedToday) {
    newSaldo3 =
      parseFloat(newSaldo) +
      parseFloat(store.state.currentCustomerEntryFeePayedToday.amount)
  } else {
    newSaldo3 = parseFloat(newSaldo)
  }
  return new Promise((resolve, reject) => {
    let time = customDateHandler.getLocalTimeFormated()
    var theTransaction = {
      amount: totalPrice,
      top_off: returnMode,
      cardleasing: {
        id: currentCustomer.id
      },
      terminal: {
        id: store.state.currentTerminalInfo.id
      },
      order: {
        order_items: orderLines,
        returnmode: returnMode
      },
      no_vat: !store.state.globalSettings.use_vat,
      description: 'bestelling kassa',
      new_saldo: newSaldo,
      time_of_transaction: time,
      time_of_transaction_with_offset: time,
      time_of_transaction_localized: customDateHandler.formatTimeAsTrueLocalTimeDateAndTime(
        time
      )
    }

    client.createItem('transactions', theTransaction).then(() => {
      return client
        .updateItem('cardleasings', currentCustomer.id, {
          saldo: newSaldo
        })
        .then(() => {
          return client.getItems('attendences', {
            filter: {
              user: {
                eq: currentCustomer.user.id
              },
              date: {
                eq: moment().format('YYYY-MM-DD')
              }
            }
          })
        })
        .then((resp) => {
          var attendence = {
            date: moment().format('YYYY-MM-DD'),
            user: {
              id: currentCustomer.user.id
            }
          }
          if (resp.data.length == 0 && shouldTriggerAttendence) {
            return client.createItem('attendences', attendence)
          } else {
            return resp
          }
        })
        .then((resp) => {
          if (chargeEntryFee) {
            let time = customDateHandler.getLocalTimeFormated()
            return client.createItem('transactions', {
              top_off: false,
              terminal: {
                id: store.state.currentTerminalInfo.id
              },
              amount: store.state.globalSettings.entry_fee,
              cardleasing: {
                id: usercard.id
              },
              description: 'stoeltjesgeld',
              no_vat: !store.state.globalSettings.use_vat,
              new_saldo: newSaldo2,
              time_of_transaction: time,
              time_of_transaction_with_offset: time,
              time_of_transaction_localized: customDateHandler.formatTimeAsTrueLocalTimeDateAndTime(
                time
              )
            })
          } else {
            if (
              boughtArticleWithNoAttendenceFlag &&
              entry_fees_today.length > 0 &&
              refund_entry_fees_today.length == 0
            ) {
              let time = customDateHandler.getLocalTimeFormated()
              return client.createItem('transactions', {
                top_off: true,
                terminal: {
                  id: store.state.currentTerminalInfo.id
                },
                amount: store.state.currentCustomerEntryFeePayedToday.amount,
                cardleasing: {
                  id: usercard.id
                },
                description: 'terugbetaling stoeltjesgeld',
                no_vat: !store.state.globalSettings.use_vat,
                new_saldo: newSaldo3,
                time_of_transaction: time,
                time_of_transaction_with_offset: time,
                time_of_transaction_localized: customDateHandler.formatTimeAsTrueLocalTimeDateAndTime(
                  time
                )
              })
            } else {
              return resp
            }
          }
        })
        .then((resp) => {
          if (chargeEntryFee) {
            return client.updateItem('cardleasings', usercard.id, {
              saldo: newSaldo2
            })
          } else {
            if (
              boughtArticleWithNoAttendenceFlag &&
              entry_fees_today.length > 0 &&
              refund_entry_fees_today.length == 0
            ) {
              return client.updateItem('cardleasings', usercard.id, {
                saldo: newSaldo3
              })
            } else {
              return resp
            }
          }
        })
        .then((resp) => {
          return resolve(resp)
        })
        .catch((err) => {
          console.log(err)
          return reject(err)
        })
    })
  })
}

service.linkCard = (store, description, type) => {
  var cardId = store.state.currentCardForLink.code
  if (store.state.currentCardForLinkUnkown) {
    var fullDesc =
      store.state.currentCustomerForLink.first_name +
      ' ' +
      store.state.currentCustomerForLink.last_name +
      ' - ' +
      cardId +
      ' (' +
      description +
      ')'
    //do flow to create card first
    return new Promise((resolve, reject) => {
      client
        .createItem('cards', {
          code: cardId
        })
        .then((resp) => {
          return client.createItem('cardleasings', {
            description: description,
            saldo: 0,
            active: true,
            from: moment().format('YYYY-MM-DD'),
            user: {
              id: store.state.currentCustomerForLink.id
            },
            card: {
              id: resp.data.id
            },
            card_leasing_type: {
              id: type.id
            },
            full_description: fullDesc
          })
        })
        .then((resp) => {
          return resolve(resp)
        })
        .catch((err) => {
          return reject(err)
        })
    })
  } else {
    return new Promise((resolve, reject) => {
      var fullDesc =
        store.state.currentCustomerForLink.first_name +
        ' ' +
        store.state.currentCustomerForLink.last_name +
        ' - ' +
        store.state.currentCardForLink.code +
        ' (' +
        description +
        ')'
      client
        .createItem('cardleasings', {
          description: description,
          saldo: 0,
          active: true,
          from: moment().format('YYYY-MM-DD'),
          user: {
            id: store.state.currentCustomerForLink.id
          },
          card: {
            id: store.state.currentCardForLink.id
          },
          card_leasing_type: {
            id: type.id
          },
          full_description: fullDesc
        })
        .then((resp) => {
          return resolve(resp)
        })
        .catch((err) => {
          return reject(err)
        })
    })
  }
}

service.createAttendence = (store) => {
  //get info from store
  var usercard = store.state.currentCustomerForAttendence
  var transactionsToday = usercard.transactions.filter((element) => {
    return moment().isSame(element.created_on, 'day')
  })
  var entry_fees_today = transactionsToday.filter((element) => {
    return element.description == 'stoeltjesgeld'
  })

  var articlesBoughtWithNoAttendenceFlag =
    transactionsToday.filter((element) => {
      if (element.order) {
        var itemsRay = element.order.order_items.filter((item) => {
          return item.no_attendence_fee
        })
        return itemsRay.length > 0
      }
    }).length > 0

  var chargeEntryFee = true
  //als er geen entry fee is --> niet aanrekenen
  if (store.state.globalSettings.entry_fee <= 0) {
    chargeEntryFee = false
  }
  //als al betaald is --> niet aanrekenen
  if (entry_fees_today.length > 0) {
    chargeEntryFee = false
  }
  //als return after buy aanstaat en er vandaag reeds iets gekocht is --> niet aanrekenen
  if (
    store.state.globalSettings.entry_fee_return_after_buy &&
    transactionsToday.length > 0
  ) {
    chargeEntryFee = false
  }
  if (usercard.card_leasing_type.no_attendence_fee) {
    chargeEntryFee = false
  }
  if (articlesBoughtWithNoAttendenceFlag) {
    chargeEntryFee = false
  }

  var attendence = {
    date: moment().format('YYYY-MM-DD'),
    user: {
      id: usercard.user.id
    }
  }
  console.log(attendence)
  var newSaldo =
    parseFloat(usercard.saldo) -
    parseFloat(store.state.globalSettings.entry_fee)

  return new Promise((resolve, reject) => {
    client
      .getItems('attendences', {
        filter: {
          user: {
            eq: usercard.user.id
          },
          date: {
            eq: moment().format('YYYY-MM-DD')
          }
        }
      })
      .then((resp) => {
        var attendence = {
          date: moment().format('YYYY-MM-DD'),
          user: {
            id: usercard.user.id
          }
        }
        if (resp.data.length == 0) {
          return client.createItem('attendences', attendence)
        } else {
          return resp
        }
      })
      .then((resp) => {
        if (chargeEntryFee) {
          let time = customDateHandler.getLocalTimeFormated()
          return client.createItem('transactions', {
            top_off: false,
            terminal: {
              id: store.state.currentTerminalInfo.id
            },
            amount: store.state.globalSettings.entry_fee,
            cardleasing: {
              id: usercard.id
            },
            description: 'stoeltjesgeld',
            no_vat: !store.state.globalSettings.use_vat,
            new_saldo: newSaldo,
            time_of_transaction: time,
            time_of_transaction_with_offset: time,
            time_of_transaction_localized: customDateHandler.formatTimeAsTrueLocalTimeDateAndTime(
              time
            )
          })
        } else {
          return resp
        }
      })
      .then((resp) => {
        if (chargeEntryFee) {
          return client.updateItem('cardleasings', usercard.id, {
            saldo: newSaldo
          })
        } else {
          return resp
        }
      })
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.createRegistration = (store) => {
  //get details for selectedEvent
  var theEvent = store.state.currentSelectedEvent
  console.log(theEvent)

  //check Current Time and day
  var currentTIme = moment()
  var currentTimeSlotFrom, currentTimeSlotTill

  //use default true to allow events without set time.
  var timeIsRightFromTill = false
  var timeIsRightPattern = false
  var noTime =
    (theEvent.from == null || theEvent.till == null) &&
    (theEvent.recurringpattern == null ||
      theEvent.recurringpattern == '' ||
      theEvent.recurringpattern_duration == null)
  if (!noTime) {
    //compare with time for the event
    if (theEvent.from != null && theEvent.till != null) {
      timeIsRightFromTill = currentTIme.isBetween(
        moment(theEvent.from),
        moment(theEvent.till)
      )
      currentTimeSlotFrom = moment(theEvent.from)
      currentTimeSlotTill = moment(theEvent.till)
    }

    //if repeatable compare with possible time
    if (theEvent.recurringpattern != null && theEvent.recurringpattern != '') {
      var options = {
        currentDate: currentTIme.toDate(),
        endDate: currentTIme.add(1, 'd').toDate,
        iteratotr: true
      }
      var interval = cronParser.parseExpression(
        theEvent.recurringpattern,
        options
      )

      var cronRay = []
      // eslint-disable-next-line no-constant-condition
      while (true) {
        try {
          var obj = interval.next()
          cronRay.push(obj.value)
          if (obj.done) {
            break
          }
        } catch (e) {
          break
        }
      }
      for (let cron in cronRay) {
        if (
          currentTIme.isBetween(
            moment(cron),
            moment(cron).add(theEvent.recurringpattern_duration, 'm')
          )
        ) {
          timeIsRightPattern = true
          currentTimeSlotFrom = moment(cron)
          currentTimeSlotTill = moment(cron).add(
            theEvent.recurringpattern_duration,
            'm'
          )
        }
      }
    }
  }
  return new Promise((resolve, reject) => {
    if (!timeIsRightFromTill && !timeIsRightPattern && !noTime) {
      return reject(
        new Error('Kan niet registreren, scan valt buiten toegelaten tijd.')
      )
    } else {
      return client
        .getItems('eventregistration', {
          fields: '*.*.*',
          filter: {
            time_of_registration: {
              between: [
                currentTimeSlotFrom.format('YYYY-MM-DD HH:mm:ss'),
                currentTimeSlotTill.format('YYYY-MM-DD HH:mm:ss')
              ]
            },
            participant: {
              eq: store.state.currentParticipant.id
            },
            event: {
              eq: theEvent.id
            }
          }
        })
        .then((resp) => {
          console.log(resp)
          var theObject = {
            event: {
              id: theEvent.id
            },
            participant: {
              id: store.state.currentParticipant.id
            },
            time_of_registration: currentTIme.format('YYYY-MM-DD HH:mm:ss')
          }
          if (resp.data.length == 0) {
            return client.createItem('eventregistration', theObject)
          } else {
            return reject(new Error('Gebruiker reeds geregistreerd'))
          }
        })
        .then((resp) => {
          return resolve(true)
        })
        .catch((rslt) => {
          return reject(rslt)
        })
    }
  })

  //get registrations for currentparticipant for currentEvent and current timeslot
  //if any --> throw error and show toast message

  //if none --> save registraion into Directus
}

service.getCardLeasingTypeOptions = (store) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('card_leasing_type', {
        fields: '*, pricelevel.*'
      })
      .then((resp) => {
        store.commit('setCardLeasingTypeOptions', resp.data)
        return resolve(resp)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getRegisteredEvents = (store) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('events', {
        fields: '*, event_type.*'
      })
      .then((resp) => {
        store.commit('setRegisteredEvents', resp.data)
        return resolve(resp)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.resetState = function (store) {
  store.commit('setCurrentCustomer', null)
  store.commit('setCheckoutCart', [])
  store.commit('setCurrentCustomerEntryFeeRefunded', false)
}

export default service
