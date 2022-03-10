const moment = require('moment')

const getLocalTimeFormated = () => {
  let time = moment()
    .local()
    .format()
  return time
}

const formatTimeAsTrueLocalTimeDateAndTime = (time) => {
  let timeFormated =
    moment(time).format('YYYY[-]MM[-]DD') + ' ' + moment(time).format('LTS')
  return timeFormated
}

module.exports = {
  getLocalTimeFormated,
  formatTimeAsTrueLocalTimeDateAndTime
}
