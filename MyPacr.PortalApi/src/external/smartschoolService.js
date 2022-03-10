var soap = require('soap')
var Promise = require('bluebird')

var toBackend = require('./directusService')
var oldImports = require('../oldimports/oldUserImport')
var moment = require('moment')
var updateHandler = require('../logic/updateHandler')
var classgroupChangeChecker = require('../logic/changeCheckers/classGroup')
var userChangeChecker = require('../logic/changeCheckers/user')

config = {}

var storage = {}

var setupService = (conf) => {
  config = conf;

  config.webserviceUrl = config.baseUrl + config.webserviceUrlPart
}

// Should probably only be used for development
var modifyWebServiceUrl = (url) => {

  config.webserviceUrl = url
}

var getServiceBaseUrl = () => {
  return config.baseUrl
}

var getServiceApiUrl = () => {
  return config.baseUrl + config.apiUrlPart
}

var syncClassLists = () => {
  var startTime = new moment()
  return new Promise((resolve, reject) => {
    var args = {
      accesscode: config.accesscode
    }

    soap
      .createClientAsync(config.webserviceUrl)
      .then(client => {
        return client.getClassListJsonAsync(args)
      })
      .then(result => {
        var resultObject = JSON.parse(result[0].return.$value)
        return Promise.mapSeries(resultObject, handleSingleClass)
      })
      .then(() => {
        return resolve('All Classes Done')
      })
      .catch(err => {
        console.log(err)
        return reject(err)
      })
      .finally(() => {
        var endTime = new moment()
        var duration = moment.duration(endTime.diff(startTime))
        console.log(
          'Synced all classgroups, time: ' +
          duration.hours() +
          'h ' +
          duration.minutes() +
          'm ' +
          duration.seconds() +
          's'
        )
      })
  })
}

var getUserDetailsByUserName = username => {
  var startTime = new moment()

  return new Promise((resolve, reject) => {
    if (username == null || username == "") {
      return resolve(null)
    }
    var args = {
      accesscode: config.accesscode,
      username: username
    }

    soap
      .createClientAsync(config.webserviceUrl)
      .then(client => {
        return client.getUserDetailsByUsernameAsync(args)
      })
      .then(result => {
        if (result) {
          return resolve(JSON.parse(result[0].return.$value))
        } else {
          return resolve(null);
        }
      })
      .catch(err => {
        console.log(err)
        return reject(err)
      })
      .finally(() => {
        var endTime = new moment()
        var duration = moment.duration(endTime.diff(startTime))
        console.log(
          'got a single user: ' +
          duration.hours() +
          'h ' +
          duration.minutes() +
          'm ' +
          duration.seconds() +
          's'
        )
      })
  })
}

var handleSingleClass = classitem => {
  var classId = 0
  return new Promise((resolve, reject) => {
    toBackend
      .getClassGroupByInternalNumber(classitem.id)
      .then(result => {
        if (result.length > 0) {
          //update
          var promise = updateHandler.updateIfChanges(
            () => classgroupChangeChecker.hasChanges(result[0], classitem),
            () => {
              return toBackend.updateClassGroup(result[0].id, classitem)
            })

          return promise
        } else {
          //create flow
          return toBackend.createClassGroup(classitem)
        }
      })
      .then(result => {
        console.log('classitem synced')
        console.log(result)
        return resolve(true)
      })
      .catch(err => {
        console.log(err)
        return reject(err)
      })
  })
}

var syncUsers = () => {
  var args = {
    accesscode: config.accesscode,
    code: '',
    recursive: ''
  }
  var nrOfAccounts = 0
  var startTime = new moment()
  return new Promise((resolve, reject) => {
    toBackend
      .getUserGroups()
      .then(result => {
        console.log('Loaded Usergroups')
        storage.Studentengroep = result.find(element => {
          return element.name == 'Studenten'
        })
        storage.Leerkrachtengroep = result.find(element => {
          return element.name == 'Leerkrachten'
        })
        storage.userGroups = result

        return toBackend.getAllClassGroups()
      })
      .then(result => {
        console.log('Loaded Classgroups')
        storage.classGroups = result
        return toBackend.getGeneralSettings()
      })
      .then(result => {
        storage.globalSettings = result[0]
      })
      .then(result => {
        return soap
          .createClientAsync(config.webserviceUrl)
          .then(client => {
            return client.getAllAccountsExtendedAsync(args)
          })
          .then(result => {
            var resultObject = JSON.parse(result[0].return.$value)
            var arrayToHandle = resultObject
            nrOfAccounts = arrayToHandle.length
            console.log(nrOfAccounts + ' items')
            return Promise.mapSeries(arrayToHandle, handleSingleUser)
          })
          .then(() => {
            return resolve('All Users & Co Accounts done')
          })
          .catch(err => {
            console.log(err)
            return reject(err)
          })
          .finally(() => {
            var endTime = new moment()
            var duration = moment.duration(endTime.diff(startTime))
            console.log(
              'Synced a total of ' +
              nrOfAccounts +
              ' Users, time: ' +
              duration.hours() +
              'h ' +
              duration.minutes() +
              'm ' +
              duration.seconds() +
              's'
            )
          })
      })
  })
}

var handleSingleUser = userItem => {
  var activeUser = {}
  var pictureObject = {}
  var pictureId
  var userGroups = []
  var Cards = []
  var dontUpdateCards = true
  var classId
  var oldCardCode = ''
  var uGroupAllreadyLinked = false

  return new Promise((resolve, reject) => {
    if (!userItem.gebruikersnaam) {
      return resolve(false)
    }
    toBackend
      .getUserByUserName(userItem.gebruikersnaam)
      .then(result => {
        //check if user exists --> if not create a mminimal version (no relational data) for the id to be made
        if (result.length <= 0) {
          return toBackend.createMinimalUser(userItem)
        } else {
          return result[0]
        }
      })
      .then(result => {
        //set the user as activeUser
        activeUser = result

        //get the picture of the user of smartschool
        if (userItem.internnummer != null) {
          return getPictureOfUser(userItem.gebruikersnaam)
        } else {
          return null
        }
      })
      .then(returnedPictureData => {
        //create the data for the picture
        pictureObject = {
          filename_disk: 'acountPhoto-' + activeUser.id + '.png',
          filename_download: 'acountPhoto-' + activeUser.id + '.png',
          data: returnedPictureData
        }
        if (returnedPictureData == null) {
          return {
            id: null
          }
        } else {
          //if a picture allready was made, only change the data, else create the picture and save the id
          if (activeUser.picture != null) {
            return updateHandler.updateIfChanges(
              () => userChangeChecker.pictureHasChanges(activeUser.picture, pictureObject),
              () => {
                return toBackend.updateImage(activeUser.picture.id, pictureObject)
              })
          } else {
            return toBackend.createImage(pictureObject)
          }
        }
      })
      .then(result => {
        pictureId = result.id

        //check if user has baseRole 1, else designate him / her as teacher
        if (userItem.basisrol == '1') {
          userGroups = [{
            usergroups_id: {
              id: storage.Studentengroep.id
            }
          }]

          var linked = activeUser.usergroup ?
            activeUser.usergroup.find(element => {
              return element.usergroups_id.id == storage.Studentengroep.id
            }) :
            null
          if (linked != null) {
            uGroupAllreadyLinked = true
          }

          //search for correct classItem
          var klasItem = userItem.groups.find(element => {
            return element.isKlas
          })

          var klasItemOurSystem = klasItem ?
            storage.classGroups.find(element => {
              return element.internal_number == klasItem.id
            }) :
            null

          classId = klasItemOurSystem ? klasItemOurSystem.id : null
        } else {
          userGroups = [{
            usergroups_id: {
              id: storage.Leerkrachtengroep.id
            }
          }]

          var linked = activeUser.usergroup ?
            activeUser.usergroup.find(element => {
              return element.usergroups_id.id == storage.Leerkrachtengroep.id
            }) :
            null
          if (linked != null) {
            uGroupAllreadyLinked = true
          }
        }

        //get cardId from the user (if any)
        // T: zoek de huidige gebruiker in de lijst met oude data?
        var oldUser = oldImports.find(element => {
          var createUserName =
            userItem.naam.toLowerCase() + '.' + userItem.voornaam.toLowerCase()
          return element.unique_token == createUserName
        })

        // T: als de oude gebruiker gevonden is
        if (
          oldUser != null &&
          oldUser.UID != null &&
          oldUser.UID != '' &&
          !dontUpdateCards
        ) {
          //get current cards from user
          //check if the card is already linked
          var theCardleasing = activeUser.card_leasings ?
            activeUser.card_leasings.find(element => {
              return element.card.code == oldUser.UID
            }) :
            null
          oldCardCode = oldUser.UID
          //if not get card from backend
          if (!theCardleasing) {
            return toBackend.getCardByCode(oldUser.UID)
          } else {
            return 'allreadyLinked'
          }
        } else {
          return 'NoInfo'
        }
      })
      .then(passOn => {
        if (passOn == 'allreadyLinked' || passOn == 'NoInfo') {
          dontUpdateCards = true
        } else {
          if (passOn == null || passOn.length <= 0) {
            var fullDesc =
              activeUser.first_name +
              ' ' +
              activeUser.last_name +
              ' - ' +
              oldCardCode +
              ' (Import van oude Data)'
            //card unknown, need to create
            return toBackend.linkUnknownCard(
              oldCardCode,
              activeUser.id,
              storage.globalSettings.default_cardleasing_type.id,
              fullDesc
            )
          } else {
            var fullDesc =
              activeUser.first_name +
              ' ' +
              activeUser.last_name +
              ' - ' +
              passOn[0].code +
              ' (Import van oude Data)'
            return toBackend.linkExisitngCard(
              passOn[0].id,
              activeUser.id,
              storage.globalSettings.default_cardleasing_type.id,
              fullDesc
            )
          }
        }
      })
      .then(result => {
        // handle co accounts
        var rayToHandle = []
        for (i = 1; i <= 6; i++) {
          if (userItem['email_coaccount' + i] != '') {
            //add to array to handle
            var objectToPush = {
              first_name: userItem['voornaam_coaccount' + i],
              last_name: userItem['naam_coaccount' + i],
              email: userItem['email_coaccount' + i],
              userId: activeUser.id
            }
            console.log(objectToPush)
            rayToHandle.push(objectToPush)
          }
        }
        console.log(rayToHandle)

        return Promise.mapSeries(rayToHandle, handleCoAccount)
      })
      .then(result => {
        return updateHandler.updateIfChanges(
          () => userChangeChecker.userHasChanges(activeUser, userItem, uGroupAllreadyLinked, classId),
          () => {
            return toBackend.updateUser(
              activeUser.id,
              userItem,
              classId,
              pictureId,
              userGroups,
              uGroupAllreadyLinked
            )
          }
        )
        // //final update of user
        // return toBackend.updateUser(
        //   activeUser.id,
        //   userItem,
        //   classId,
        //   pictureId,
        //   userGroups,
        //   uGroupAllreadyLinked
        // )
      })
      .then(resp => {
        console.log(resp)
        return resolve(resp.data)
      })
      .catch(err => {
        console.log(err)
        return reject(err)
      })
      .finally(() => {
        console.log('synced user: ' + userItem.gebruikersnaam)
      })
  })
}

var handleCoAccount = coAccount => {
  var activeCoAccount
  var usersArray = []
  return new Promise((resolve, reject) => {
    toBackend
      .getCoAccountByEmail(coAccount.email)
      .then(result => {
        if (result.length > 0) {
          activeCoAccount = result[0]
          return activeCoAccount
        } else {
          return toBackend.createCoAccount(coAccount)
        }
      })
      .then(result => {
        //check if user is allready linked to coaccount
        activeCoAccount = result
        console.log(activeCoAccount)
        var linkedUser = activeCoAccount.users ?
          activeCoAccount.users.find(element => {
            return element.users_id == coAccount.userId
          }) :
          null

        if (linkedUser == null) {
          usersArray.push({
            users_id: {
              id: coAccount.userId
            }
          })
        }
        //Todo check if coAccount's props are named this way (first_name,...)
        let updateObj = {
          first_name: coAccount.first_name,
          last_name: coAccount.last_name,
          email: coAccount.email
        }
        return updateHandler.updateIfChanges(
          () => userChangeChecker.coAccountHasChanges(activeCoAccount, updateObj, usersArray),
          () => {
            return toBackend.updateCoAccount(updateObj,
              activeCoAccount.id,
              usersArray
            )
          }
        )
        // return toBackend.updateCoAccount(updateObj,
        //   activeCoAccount.id,
        //   usersArray
        // )
      })
      .then(result => {
        return resolve('synced CoAccount')
      })
      .catch(err => {
        return reject(err)
      })
  })
}

var getPictureOfUser = gebruikersnaam => {
  return new Promise((resolve, reject) => {
    var args = {
      accesscode: config.accesscode,
      userIdentifier: gebruikersnaam
    }

    soap
      .createClientAsync(config.webserviceUrl)
      .then(client => {
        return client.getAccountPhotoAsync(args)
      })
      .then(result => {
        var resultObject = result[0].return.$value
        if (resultObject.length < 5) {
          return resolve(null)
        }
        return resolve(resultObject)
      })
      .catch(err => {
        return reject(err)
      })
  })
}

var sendMsgToAllCoAccounts = payLoad => {
  var body = payLoad.msg
  var userIdentifier = payLoad.username
  var title = payLoad.title

  var payLoadRay = []

  return new Promise((resolve, reject) => {
    getUserDetailsByUserName(userIdentifier)
      .then(resp => {
        if (resp) {
          //set Co Account Flow
          var rayToHandle = []
          for (i = 1; i <= 6; i++) {
            if (resp['email_coaccount' + i] != '') {
              //add to array to handle
              var objectToPush = {
                username: userIdentifier,
                title: title,
                body: body,
                coAccountId: i
              }
              rayToHandle.push(objectToPush)
            }
          }

          return Promise.mapSeries(rayToHandle, sendMsgToSingleCoAccount)
        } else {
          console.log('Getting user details from smart school failed')
          return null
        }
      })
      .then(resp => {
        return resolve(true)
      })
      .catch(err => {
        console.log(err)
        return reject(err)
      })
  })
}

var sendMsgToSelectiveCoAccounts = payLoad => {
  var body = payLoad.msg
  var userIdentifier = payLoad.username
  var title = payLoad.title
  var cardId = payLoad.cardId
  //var coAccountEmails = payLoad.coAccountEmails

  var payLoadRay = []
  var rayToHandle = []

  return new Promise((resolve, reject) => {
    getUserDetailsByUserName(userIdentifier)
      .then(resp => {
        if (resp) {
          //set Co Account Flow

          for (i = 1; i <= 6; i++) {
            if (resp['email_coaccount' + i] != '') {
              //add to array to handle
              var objectToPush = {
                username: userIdentifier,
                title: title,
                body: body,
                coAccountId: i,
                email: resp['email_coaccount' + i]
              }
              payLoadRay.push(objectToPush)
            }
          }

          // return Promise.mapSeries(rayToHandle, sendMsgToSingleCoAccount)
          var emails = []
          payLoadRay.forEach(element => {
            emails.push(element.email)
          })
          return toBackend.getCoAccountsByEmail(emails)
        } else {
          console.log('Getting user details from smart school failed')
          return null
        }
      })
      .then(resp => {
        if (resp) {
          payLoadRay.forEach(element => {
            var keepIt = false
            resp.forEach(innerElement => {
              if (element.email == innerElement.email) {
                innerElement.allowed_card_leasings.forEach(CLElement => {
                  if (CLElement.cardleasings_id.id == cardId) {
                    keepIt = true
                  }
                });
              }
            })
            if (keepIt) {
              rayToHandle.push(element)
            }
          })
          return Promise.mapSeries(rayToHandle, sendMsgToSingleCoAccount)
        } else {
          return null
        }
      })
      .then(resp => {
        return resolve(true)
      })
      .catch(err => {
        console.log(err)
        return reject(err)
      })
  })
}

var sendMsgToSingleCoAccount = payLoad => {
  var body = payLoad.body
  var userIdentifier = payLoad.username
  var title = payLoad.title
  var coAccountId = payLoad.coAccountId

  return new Promise((resolve, reject) => {
    var args = {
      accesscode: config.accesscode,
      userIdentifier: userIdentifier,
      title: title,
      body: body,
      coaccount: coAccountId
    }
    soap
      .createClientAsync(config.webserviceUrl)
      .then(client => {
        return client.sendMsgAsync(args)
      })
      .then(resp => {
        return resolve(true)
      })
      .catch(err => {
        console.log(err)
        return reject(err)
      })
      .finally(() => {
        console.log(
          'Send Message for user: ' +
          userIdentifier +
          ' co account Id: ' +
          coAccountId
        )
      })
  })
}

module.exports = {
  setupService,
  getServiceBaseUrl,
  getServiceApiUrl,
  syncClassLists,
  syncUsers,
  getUserDetailsByUserName,
  sendMsgToAllCoAccounts,
  sendMsgToSelectiveCoAccounts,
  modifyWebServiceUrl
}