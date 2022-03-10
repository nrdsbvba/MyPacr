import tobackend from '~/plugins/2backend.js'

export default function({ store }) {
  if (tobackend.isLoggedIn(store)) {
    if (!store.state.globalSettings) {
      //Get global settings
      tobackend.getGlobalSettings(store).then(() => {
        //wait for complete
      })
    }
    if (!store.state.terminalOptions) {
      //Get terminal options
      tobackend.getTerminalOptions(store).then(() => {
        //wait for complete
      })
    }
    if (!store.state.cardLeasingTypeOptions) {
      tobackend.getCardLeasingTypeOptions(store).then(() => {})
    }
  }
}
