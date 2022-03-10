import moment from 'moment'

window.onNuxtReady(() => {
    let locale = window.navigator.userLanguage || window.navigator.language;
    moment.locale(locale);
    console.log('Moment Locale set to:' +locale)
  })