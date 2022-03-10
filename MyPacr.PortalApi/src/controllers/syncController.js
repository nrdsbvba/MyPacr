const express = require('express')
const router = express.Router()
const passport = require('passport')
const jwt = require('jsonwebtoken')

const smartSchoolService = require('../external/smartschoolService')
const maintenanceService = require('../service/maintenanceService')
const config = require('config')

const hardcodedPassphrases = {
  classLists: config.get("syncPassphrases").classLists,
  users: config.get("syncPassphrases").users,
  merge: config.get("syncPassphrases").merge,
  RepairAttendence: config.get("syncPassphrases").repairAttendence,
  fillfulldesc: config.get("syncPassphrases").fillfulldesc,
  OrderLineFix: config.get("syncPassphrases").orderLineFix
}

router.post('/classLists', (req, res) => {
  let passphrase = req.body.passphrase
  if (passphrase == hardcodedPassphrases.classLists) {
    res.status(200).send('started sync for classlists')
    smartSchoolService
      .syncClassLists()
      .then(result => {
        console.log('synced classes')
      })
      .catch(err => {
        console.log('Error ' + err)
      })
  } else {
    res.status(400).send('no-access')
  }
})

router.post('/users', (req, res) => {
  let passphrase = req.body.passphrase
  if (passphrase == hardcodedPassphrases.users) {
    res.status(200).send('started sync for users')
    smartSchoolService
      .syncUsers()
      .then(result => {
        console.log('synced users')
      })
      .catch(err => {
        console.log('Error: ' + err)
      })
  } else {
    res.status(400).send('no-access')
  }
});

router.post('/merge', (req, res) => {
  let passphrase = req.body.passphrase
  if (passphrase == hardcodedPassphrases.merge) {
    res.status(200).send('started card merge flow')
    maintenanceService
      .handleCardMergeMaintenance({
        excludeCardTypes:[4]
      })
      .then(result => {
        console.log('merged cards')
      })
      .catch(err => {
        console.log('Error: ' + err)
      })
  } else {
    res.status(400).send('no-access')
  }
});

router.post('/repairAttendence', (req, res) => {
  let passphrase = req.body.passphrase
  if (passphrase == hardcodedPassphrases.RepairAttendence) {
    res.status(200).send('started repairAtendence')
    maintenanceService
      .handleAttendanceMaintenances()
      .then(result => {
        console.log('repairde attendences fees')
      })
      .catch(err => {
        console.log('Error: ' + err)
      })
  } else {
    res.status(400).send('no-access')
  }
});

router.post('/fillfulldesc', (req, res) => {
  let passphrase = req.body.passphrase
  if (passphrase == hardcodedPassphrases.fillfulldesc) {
    res.status(200).send('started fillfulldesc')
    maintenanceService
      .handleFillFullDescription()
      .then(result => {
        console.log('cardtransfersHandled')
      })
      .catch(err => {
        console.log('Error: ' + err)
      })
  } else {
    res.status(400).send('no-access')
  }
});

router.post('/orderlineFix', (req, res)=>{
  let passphrase = req.body.passphrase
  if (passphrase == hardcodedPassphrases.OrderLineFix) {
    res.status(200).send('started orderlineFix')
    maintenanceService
      .handleOrderLineFix()
      .then(result => {
        console.log('orderlines fixed')
      })
      .catch(err => {
        console.log('Error: ' + err)
      })
  } else {
    res.status(400).send('no-access')
  }
});

module.exports = router
