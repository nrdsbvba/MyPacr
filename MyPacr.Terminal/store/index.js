
export const state = () => {
  return {
    auth: null,
    articleList: null,
    loggedInInfo: null,
    checkoutCart: [],
    activePriceLevel: null,
    currentCustomer: null,
    currentCustomerEntryFeePayedToday: null,
    currentCustomerEntryFeeRefunded: false,
    currentUserGroupString: '',
    currentlyTyping: false,
    userGroups: [],
    globalSettings: null,
    terminalOptions: null,
    currentTerminalInfo: null,
    currentCustomerForLink: null,
    currentCardForLink: null,
    currentCardForLinkUnkown: false,
    currentCardForLinkInUse: false,
    currentCustomerForAttendence: null,
    cardLeasingTypeOptions: null,
    salesMode: false,
    registeredEvents: [],
    currentSelectedEvent: null,
    currentParticipant: null
  }
}
export const mutations = {
  setAuth(state, auth) {
    state.auth = auth
  },
  setArticleList(state, articleList) {
    state.articleList = articleList
  },
  setLoggedInInfo(state, loggedInInfo) {
    state.loggedInInfo = loggedInInfo
  },
  setCheckoutCart(state, checkoutCart) {
    state.checkoutCart = checkoutCart
  },
  setCurrentlyTyping(state, currentlyTyping) {
    state.currentlyTyping = currentlyTyping
  },
  setCurrentCustomer(state, currentCustomer) {
    state.currentCustomer = currentCustomer
  },
  setUserGroups(state, userGroups) {
    state.userGroups = userGroups
  },
  setCurrentUserGroupString(state, userGroupString) {
    state.userGroupString = userGroupString
  },
  setActivePriceLevel(state, activePriceLevel) {
    state.activePriceLevel = activePriceLevel
  },
  setGlobalSettings(state, globalSettings) {
    state.globalSettings = globalSettings
  },
  setTerminalOptions(state, terminalOptions) {
    state.terminalOptions = terminalOptions
  },
  setCurrentTerminalInfo(state, currentTerminalInfo) {
    state.currentTerminalInfo = currentTerminalInfo
  },
  setCurrentCustomerForLink(state, currentCustomerForLink) {
    state.currentCustomerForLink = currentCustomerForLink
  },
  setCurrentCardForLink(state, currentCardForLink) {
    state.currentCardForLink = currentCardForLink
  },
  setCurrentCardForLinkUnkown(state, currentCardForLinkUnkown) {
    state.currentCardForLinkUnkown = currentCardForLinkUnkown
  },
  setCurrentCardForLinkInUse(state, currentCardForLinkInUse) {
    state.currentCardForLinkInUse = currentCardForLinkInUse
  },
  setCurrentCustomerForAttendence(state, currentCustomerForAttendence) {
    state.currentCustomerForAttendence = currentCustomerForAttendence
  },
  setCurrentCustomerEntryFeePayedToday(
    state,
    currentCustomerEntryFeePayedToday
  ) {
    state.currentCustomerEntryFeePayedToday = currentCustomerEntryFeePayedToday
  },
  setCurrentCustomerEntryFeeRefunded(state, currentCustomerEntryFeeRefunded) {
    state.currentCustomerEntryFeeRefunded = currentCustomerEntryFeeRefunded
  },
  setCardLeasingTypeOptions(state, cardLeasingTypeOptions) {
    state.cardLeasingTypeOptions = cardLeasingTypeOptions
  },
  setSalesMode(state, salesMode) {
    state.salesMode = salesMode
  },
  setRegisteredEvents(state, registeredEvents) {
    state.registeredEvents = registeredEvents
  },
  setCurrentSelectedEvent(state, currentSelectedEvent) {
    state.currentSelectedEvent = currentSelectedEvent
  },
  setCurrentParticipant(state, currentParticipant) {
    state.currentParticipant = currentParticipant
  },
  addToCheckOutCart(state, payload) {
    var article = payload.article
    var number = payload.number

    //determine price
    var price = 0

    if (state.activePriceLevel) {
      //find the price with that pricelevel
      var thePriceA = article.prices.find((element) => {
        return element.pricelevel == state.activePriceLevel.id
      })

      //if none, take fallback price
      if (!thePriceA) {
        thePriceA = article.fallback_price
      } else {
        thePriceA = thePriceA.amount
      }
      price = thePriceA
    } else {
      //check default pricelevel in settings
      var thePriceB = article.prices.find((element) => {
        return element.pricelevel == state.globalSettings.default_pricelevel.id
      })

      //if default privelevel not in pricesarray  get fallback price
      if (!thePriceB) {
        thePriceB = article.fallback_price
      } else {
        thePriceB = thePriceB.amount
      }
      price = thePriceB
    }

    //check if there is allready a line with the article
    var checkoutItem = state.checkoutCart.find((item) => {
      return item.article.id == article.id
    })
    if (checkoutItem) {
      checkoutItem.number = parseInt(checkoutItem.number) + parseInt(number)
      checkoutItem.cost = price * parseInt(checkoutItem.number)
    } else {
      var cost = 0

      cost = price * number

      state.checkoutCart.push({
        article: article,
        articleName: article.name,
        number: number,
        cost: cost
      })
    }
  },
  recalculateShoppingCart(state, payload) {
    if (payload) {
      var newArray = []
      state.checkoutCart.forEach((checkOutItem) => {
        var price = 0

        if (state.activePriceLevel) {
          //find the price with that pricelevel
          var thePriceA = checkOutItem.article.prices.find((element) => {
            return element.pricelevel == state.activePriceLevel.id
          })

          //if none, take fallback price
          if (!thePriceA) {
            thePriceA = checkOutItem.article.fallback_price
          } else {
            thePriceA = thePriceA.amount
          }
          price = thePriceA
        } else {
          //check default pricelevel in settings
          var thePriceB = checkOutItem.article.prices.find((element) => {
            return (
              element.pricelevel == state.globalSettings.default_pricelevel.id
            )
          })

          //if default privelevel not in pricesarray  get fallback price
          if (!thePriceB) {
            thePriceB = checkOutItem.article.fallback_price
          } else {
            thePriceB = thePriceB.amount
          }
          price = thePriceB
        }

        checkOutItem.cost = parseInt(checkOutItem.number) * price
        newArray.push({
          article: checkOutItem.article,
          articleName: checkOutItem.article.name,
          number: checkOutItem.number,
          cost: checkOutItem.cost
        })
      })
      state.checkoutCart = newArray
    }
  },
  subsctractSingleFromCheckoutCart(state, incomingCheckoutItem) {
    var article = incomingCheckoutItem.article
    //determine price
    var price = 0

    if (state.activePriceLevel) {
      //find the price with that pricelevel
      var thePriceA = article.prices.find((element) => {
        return element.pricelevel == state.activePriceLevel.id
      })

      //if none, take fallback price
      if (!thePriceA) {
        thePriceA = article.fallback_price
      } else {
        thePriceA = thePriceA.amount
      }
      price = thePriceA
    } else {
      //check default pricelevel in settings
      var thePriceB = article.prices.find((element) => {
        return element.pricelevel == state.globalSettings.default_pricelevel.id
      })

      //if default privelevel not in pricesarray  get fallback price
      if (!thePriceB) {
        thePriceB = article.fallback_price
      } else {
        thePriceB = thePriceB.amount
      }
      price = thePriceB
    }
    var checkoutItem = state.checkoutCart.find((item) => {
      return item.article.id == incomingCheckoutItem.article.id
    })
    if (checkoutItem) {
      checkoutItem.number = parseInt(checkoutItem.number) - 1
      if (checkoutItem.number <= 0) {
        var newArray = state.checkoutCart.filter((item) => {
          return item.article.id != incomingCheckoutItem.article.id
        })
        state.checkoutCart = newArray
      } else {
        if (!state.activePriceLevel) {
          checkoutItem.cost = price * parseInt(checkoutItem.number)
        }
      }
    }
  },
  SubstractArticleLineFromCheckoutCard(state, incomingCheckoutItem) {
    var newArray = state.checkoutCart.filter((item) => {
      return item.article.id != incomingCheckoutItem.article.id
    })
    state.checkoutCart = newArray
  }
}
export const actions = {}
