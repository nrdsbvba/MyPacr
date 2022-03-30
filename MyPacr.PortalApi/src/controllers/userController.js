const express = require('express')
const router = express.Router()
const passport = require('passport')
const jwt = require('jsonwebtoken')
const config = require('config')
const axios = require('axios')
const qs = require('qs')
const userService = require('../service/userService')
const smartschoolService = require('../external/smartschoolService')
const { UsersHandler } = require('@directus/sdk')

router.post('/register', (req, res, next) => {
  userService
    .createOwnCoAccount(req.body.account)
    .then((result) => {
      result.token = jwt.sign({
        username: result.FullAccount.email
      },
        config.get('jwt').secret
      )
      res.status(200).send(result)
    })
    .catch(err => {
      res.status(500).send(err)
    })
});

router.post('/authenticate', (req, res, next) => {
  let user = {
    email: req.body.email,
    password: req.body.password
  }
  console.log("Authenticate")
  userService.handleOwnLogin(user)
    .then((result) => {
      result.token = jwt.sign({
        username: result.FullAccount.email,
        expiresIn: '1 days'
      },
        config.get('jwt').secret
      )
      console.log(result)
      res.status(200).send(result)
    })
    .catch(err => {
      console.log(err)
      res.status(500).send(err)
    })
})

router.post('/Smartschoolauthenticate', (req, res, next) => {
  const portalSettings = config.get('portalSettings')
  var theBody = {
    grant_type: 'authorization_code',
    client_id: config.get('smartschoolAuthentication').clientID,
    client_secret: config.get('smartschoolAuthentication').clientSecret,
    redirect_uri: portalSettings.urlFront + '/#/smartschoolauth',
    code: req.body.code,
    scope: 'userinfo fulluserinfo groupinfo'
  }
  var testmode = req.body.testMode
  handlePromisChainStart(testmode, theBody)
    .then(resp => {
      if (resp == null && testmode) {
        return {}
      }
      if (resp.data) {
        return axios.get(
          smartschoolService.getServiceApiUrl() + '/userinfo?access_token=' +
          resp.data.access_token
        )
      } else {
        return null
      }
    })
    .then(resp => {
      if (testmode) {
        resp = {}
        resp.data = {
          username: 'test.persoon',
          nrCoAccount: 1
        }
      }
      if (!resp) {
        res.json({
          error: true,
          data: 'Kan niet inloggen, sommige benodigde data is onbereikbaar of niet bestaande in smartschool'
        })
        if (req.session) req.session.destroy()
      } else {

        return userService.handleSmartSchoolLogin(resp.data)

      }
    })
    .then(result => {
      //TODO: get secret for JWT token from general settings in directus
      if (result) {
        if (!result.error) {
          result.token = jwt.sign({
            username: result.FullAccount.email
          },
            config.get('jwt').secret
          )
        }
        res.json(result)
      }
    })
    .catch(err => {
      if (req.session) req.session.destroy()
      if (err.data) {
        console.log(err.data.error_description)
      }
      res.json(err)
    })
})
router.post('/loggedIn', (req, res, next) => {
  return res.json(req.session.loginObject != null)
})

router.post('/logout', (req, res, next) => {
  if (req.session) req.session.destroy()
  res.json(true)
})

var handlePromisChainStart = (testMode, theBody) => {
  return new Promise((resolve, reject) => {
    if (testMode) {
      return resolve(false)
    } else {
      return resolve(
        axios.post(
          smartschoolService.getServiceBaseUrl() + '/OAuth/index/token',
          qs.stringify(theBody), {
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          }
        }
        )
      )
    }
  })
}

router.post('/authProviderSettings', (req, res, next) => {
  // Please note Requires server restart for updates!
  if (global.generalSettings.auth_provider_settings === null) {
    res.status(500).send("No Auth provider settings set on server.")
  } else {
    res.status(200).send(global.generalSettings.auth_provider_settings)
  }

});

module.exports = router