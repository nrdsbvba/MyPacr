const express = require('express')
const router = express.Router()
const jwt = require('jsonwebtoken')
const reportingService = require('../service/reportingService')
const config = require('config')

var passphrase = config.get('reporting').passphrase
router.post('/generateReport', (req, res) => {
  var auth = req.header('x-auth')
  //get parameters
  var decoded = jwt.verify(auth, config.get('jwt').secret)

  if (decoded.passphrase != passphrase) {
    res.status(401).send('UnAuthorized')
  } else {
    reportingService
      .generateReport(req.body)
      .then(result => {
        console.log('generated Report')
        res.status(200).json(result)
      })
      .catch(err => {
        console.log('Error ' + err)
        res.status(500).json(err)
      })
  }
})

module.exports = router;
