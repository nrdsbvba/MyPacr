const directusService = require('../external/directusService')
const smartschoolService = require('../external/smartschoolService')
const Promise = require('bluebird')
const crypto = require('crypto');
const argon = require('argon2');
const util = require('util');

var createSalt = util.promisify(crypto.randomBytes);

var getHashedPassword = password => {
  return new Promise((resolve, reject) => {
    createSalt(32).then(result => {
      argon.hash(password, result)
        .then(hashedpsw => {
          return resolve(hashedpsw)
        })
        .catch(err => {
          return reject(err)
        })
    })
      .catch(err => {
        return reject(err)
      })
  })
}

var getById = id => {
  return directusService.getCoAccountById(id)
}

var getByEmail = email => {
  return directusService.getByEmail(email)
}

var comparePassword = (user, password) => { }

var handleOwnLogin = user => {
  var loginObject = {}
  var authSettingsOwn = global.generalSettings.auth_provider_settings
  return new Promise((resolve, reject) => {
    if (authSettingsOwn.enabled === false) {
      return reject("Autentication method own not enabled in global settings")
    } else {
      directusService.getCoAccountByEmail(user.email)
        .then(coAccount => {
          var directusAccount = coAccount[0]
          loginObject.FullAccount = directusAccount
          return argon.verify(directusAccount.password, user.password);
        })
        .then(passwordMatch => {
          if (passwordMatch) {
            return directusService.getCoAccountById(loginObject.FullAccount.id)
          } else {
            return reject('Login credentials incorrect')
          }
        })
        .then((fullCoAccount) => {
          loginObject.FullAccount = fullCoAccount
          return resolve(loginObject);
        })
        .catch(err => {
          console.log(err);
          return reject(err)
        })
    }
  })
}

var handleSmartSchoolLogin = userinfo => {
  console.log(userinfo)
  var loginObject = {}
  var nrCoAccount = 0
  var tokenCoAccount = null
  var userObject = []
  var coAccountEmail = null
  var authSettingsSmartschool = global.generalSettings.auth_provider_settings.smartschool
  return new Promise((resolve, reject) => {
    if (authSettingsSmartschool.enabled === false) {
      return reject("Autentication method smartschool not enabled in global settings")
    } else {
      //get user (student) from userinfo through smartschool api
      smartschoolService
        .getUserDetailsByUserName(userinfo.username)
        .then(userFromSmartschool => {
          loginObject.userFromSmartschool = userFromSmartschool

          //get user (student) from internal system by username
          return directusService.getUserByUserName(userinfo.username)
        })
        .then(userFromDirectus => {
          //if username does not exist --> error out, should not do entire sync flow for one user
          if (userFromDirectus.length <= 0) {
            return resolve({
              error: true,
              data: 'Kan gebruiker niet terugvinden in onze systemen, hou er rekening mee dat het tot 24 uur kan duren voor een smartschoolgebruiker gesynchroniseerd wordt naar dit systeem'
            })
          } else {
            loginObject.userFromDirectus = userFromDirectus[0]
          }
          if (userinfo.isCoAccount) {
            nrCoAccount = userinfo.nrCoAccount

            coAccountEmail =
              loginObject.userFromSmartschool['email_coaccount' + nrCoAccount]
            tokenCoAccount = {
              first_name: loginObject.userFromSmartschool[
                'voornaam_coaccount' + nrCoAccount
              ],
              last_name: loginObject.userFromSmartschool['naam_coaccount' + nrCoAccount],
              email: loginObject.userFromSmartschool['email_coaccount' + nrCoAccount],
              userId: loginObject.userFromDirectus.id
            }
          } else {
            var allowed = false
            console.log(userFromDirectus[0])
            userFromDirectus[0].usergroup.forEach(element => {
              if (
                global.generalSettings.usergroups_allowed_to_login_into_portal.includes(
                  element.usergroups_id.name
                )
              ) {
                allowed = true
              }
            })
            if (allowed) {
              if (
                loginObject.userFromSmartschool['emailadres'] != null &&
                loginObject.userFromSmartschool['emailadres'] != ''
              ) {
                coAccountEmail = loginObject.userFromSmartschool['emailadres']
                tokenCoAccount = {
                  first_name: loginObject.userFromSmartschool['voornaam'],
                  last_name: loginObject.userFromSmartschool['naam'],
                  email: loginObject.userFromSmartschool['emailadres'],
                  userId: loginObject.userFromDirectus.id
                }
              } else {
                return resolve({
                  error: true,
                  data: 'Deze gebruiker kan niet inloggen in de portal omdat het emailadres niet ingevuld is op de smartschool account'
                })
              }
            } else {
              return resolve({
                error: true,
                data: 'Deze gebruiker heeft geen toelating om de portal te gebruiken'
              })
            }
          }

          return directusService.getCoAccountByEmail(coAccountEmail)
        })
        .then(result => {
          if (result.length > 0) {
            loginObject.activeCoAccount = result[0]
            return loginObject.activeCoAccount
          } else {
            return directusService.createCoAccount(tokenCoAccount)
          }
        })
        .then(result => {
          activeCoAccount = result
          var linkedUser = activeCoAccount.users ?
            activeCoAccount.users.find(element => {
              return element.users_id == tokenCoAccount.userId
            }) :
            null

          if (linkedUser == null) {
            userObject.push({
              users_id: {
                id: tokenCoAccount.userId
              }
            })
          }
          return directusService.updateCoAccount({
            first_name: activeCoAccount.first_name,
            last_name: activeCoAccount.last_name,
            email: activeCoAccount.email
          },
            activeCoAccount.id,
            userObject
          )
        })
        .then(result => {
          return directusService.getCoAccountById(result.id)
        })
        .then(result => {
          loginObject.FullAccount = result
          return resolve(loginObject)
        })
        .catch(err => {
          return reject(err)
        })

      //get all cards linked to coaccount

      //pass back the entire enriched object
    }
  })
}

var createOwnCoAccount = (account) => {
  return new Promise((resolve, reject) => {
    var loginObject = {}
    directusService.getCoAccountByEmail(account.email)
      .then((coAccount) => {
        if (coAccount.length > 0) {
          return reject('Email taken.')
        } else {
          // todo setup password.
          getHashedPassword(account.password)
            .then(result => {
              account.password = result
              return directusService.createCoAccount(account)
                .then(result => {
                  loginObject.FullAccount = result
                  loginObject.FullAccount.users = []
                  return resolve(loginObject)
                })
                .catch(err => {
                  return reject(err)
                })
            })
            .catch(err => {
              return reject(err)
            })
        }
      })
      .catch(err => {
        return reject(err)
      })
  })
}

module.exports = {
  getByEmail,
  getById,
  comparePassword,
  handleSmartSchoolLogin,
  createOwnCoAccount,
  handleOwnLogin
}