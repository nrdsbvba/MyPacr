var cron = require('node-cron')
const moment = require('moment')
const smartSchoolService = require('../external/smartschoolService')
const attendenceService = require('./attendenceService')
const saldoService = require('./saldoService')

let settings = {}
const setupService = (config) => {
  settings = config;
}
const smartschoolImport = () => {
  cron.schedule('0,50 3 * * *', () => {
    var jobToRun
    switch (new Date().getMinutes()) {
      case 0:
        jobToRun = smartSchoolService.syncClassLists
        break
      case 50:
        jobToRun = smartSchoolService.syncUsers
        break
      default:
        break
    }
    jobToRun()
  })
}

const heartline = () => {
  cron.schedule('0 0-23 * * *', () => {
    var d = moment().format("dddd, MMMM Do YYYY, HH:mm:ss");
    var l = moment().local().format("dddd, MMMM Do YYYY, HH:mm:ss");
    console.log("sever Time: " + d);
    console.log("sever local Time: " + l);
  })
}

const AttendenceControl = () => {
  cron.schedule('0 14 * * *', () => {
    var jobToRun = attendenceService.handleAttendences
    jobToRun()
  })
}
const SaldoControl = () => {
  cron.schedule('15 15 * * *', () => {
    var jobToRun = saldoService.handleLowBalanceChecks
    jobToRun()
  })
}

const startCronJob = () => {
  if (settings.cronJobsEnabled) {
    console.log('CronJobs are enabled!')
    smartschoolImport();
    heartline();
    AttendenceControl();
    SaldoControl();
  } else {
    console.log('CronJobs are disabled')
  }
}

module.exports = {
  startCronJob,
  setupService
}