const moment = require('moment')
const Promise = require('bluebird')

const directusService = require('../external/directusService')

var runControles = (options) => {
  //haal alle exceptions op
  return new Promise((resolve, reject) => {
    var startTime = new moment()
    nrOfAccounts = 0
    var currentDate = moment().format('YYYY-MM-DD')
    var currentTime = moment().format('YYYY-MM-DD HH:mm:ss')

    var controleExceptions = []
    directusService
      .getControleExceptionsForCurrentDay(currentDate)
      .then((resp) => {
        controleExceptions = resp

        var globalException = controleExceptions.some((element) => {
          return element.global
        })
        if (globalException) {
          console.log('Global Exception found for current date fonr Controles')
          return null
        } else {
          return directusService.getAllControles()
        }
      })
      .then((resp) => {
        if (resp) {
          var payloadRay = []
          resp.forEach((element) => {
            payloadRay.push({
              controle: element,
              options: options,
              exceptions: controleExceptions,
            })
          })
          nrOfAccounts = payloadRay.length
          return Promise.mapSeries(payloadRay, handleSingleControle) //TODO: create handleSingleControle
        } else {
          return null
        }
      })
      .then(() => {
        return resolve('All Controles Handled')
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
      .finally(() => {
        var endTime = new moment()
        var duration = moment.duration(endTime.diff(startTime))
        console.log(
            "Handled a total of " +
              nrOfAccounts +
              " Controles, time: " +
              duration.hours() +
              "h " +
              duration.minutes() +
              "m " +
              duration.seconds() +
              "s"
          );
      })
  })

  //per controle
  //haal alle exceptions op
  //haal event registrations op
  //check registrations
  //doe check per soort
  // bij problemen schrijf weg naar Controleresults
}
