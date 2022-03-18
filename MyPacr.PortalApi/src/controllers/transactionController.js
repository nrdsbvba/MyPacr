const express = require('express')
const router = express.Router()
const jwt = require('jsonwebtoken')
const directusService = require('../external/directusService')
const config = require('config')

router.post('/getTransactionsPaginated', (req, res) => {
    var auth = req.header('x-auth')
    //get parameters
    var coaccountEmail = req.body.email
    var decoded = jwt.verify(auth, config.get('jwt').secret)
  
    if (decoded.username != coaccountEmail) {
      res.status(401).send('UnAuthorized')
    } else {
      var limit = req.body.limit
      var pageNumber = req.body.pageNumber
      var cardLeasingId = req.body.cardLeasingId
      directusService
        .getPagedTransactions(limit, pageNumber, cardLeasingId)
        .then(result => {
          res.status(200).send(result)
        })
        .catch(err => {
          res.status(500).send(err)
          console.log(err)
        })
    }
  })
  router.post('/getTransactionsCount', (req, res) => {
    var auth = req.header('x-auth')
    //get parameters
    var coaccountEmail = req.body.email
    var decoded = jwt.verify(auth, config.get('jwt').secret)
  
    if (decoded.username != coaccountEmail) {
      res.status(401).send('UnAuthorized')
    } else {

      var cardLeasingId = req.body.cardLeasingId
      directusService
        .getTransactionsCount(cardLeasingId)
        .then(result => {
          res.status(200).send({rows:result})
        })
        .catch(err => {
          res.status(500).send(err)
          console.log(err)
        })
    }
  })

  module.exports = router