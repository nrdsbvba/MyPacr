const express = require('express')
const router = express.Router()
const jwt = require('jsonwebtoken')
const directusService = require('../external/directusService')
const config = require('config')

router.post('/getAttendenceProfiles', (req, res) => {
  var auth = req.header('x-auth')
  //get parameters
  var coaccountEmail = req.body.email
  var decoded = jwt.verify(auth, config.get('jwt').secret)

  if (decoded.username != coaccountEmail) {
    res.status(401).send('UnAuthorized')
  } else {
    var userIds = req.body.userIds
    directusService
      .getAttendenceProfiles(userIds)
      .then(result => {
        res.status(200).send(result)
      })
      .catch(err => {
        res.status(500).send(err)
        console.log(err)
      })
  }
})

router.post('/saveAttendenceProfile', (req, res) => {
  var auth = req.header('x-auth')
  //get parameters
  var coaccountEmail = req.body.email
  var decoded = jwt.verify(auth, config.get('jwt').secret)

  if (decoded.username != coaccountEmail) {
    res.status(401).send('UnAuthorized')
  } else {
    var attendenceProfile = req.body.attendenceProfile
    directusService
      .saveAttendenceProfile(attendenceProfile)
      .then(result => {
        res.status(200).send(result)
      })
      .catch(err => {
        res.status(500).send(err)
        console.log(err)
      })
  }
})

module.exports = router
