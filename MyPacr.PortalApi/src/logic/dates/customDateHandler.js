const momentTimeZone = require("moment-timezone");
const moment = require("moment");
const config = require("config");

const getLocalTimeFormated = () => {
  const timeZone = config.get('localizationSettings').timezone
  let time = momentTimeZone()
    .tz(timeZone)
    .format();
  return time;
};

const formatTimeAsTrueLocalTimeDateAndTime = time => {
  let timeFormated =
    moment(time).format("YYYY[-]MM[-]DD") + "T" + moment(time).format("LTS");
  return timeFormated;
};

module.exports = {
  getLocalTimeFormated,
  formatTimeAsTrueLocalTimeDateAndTime
};
