import cookiePlugin from '~/plugins/vue-cookie.js'
import tobackend from '~/plugins/2backend.js'

export default function(context) {
  var theCookie = cookiePlugin.get('terminalinfo')
  if (!theCookie) {
    return context.redirect('/terminalSetup')
  } else {
    //check if logged in
    if (tobackend.isLoggedIn(context.store)) {
      if (!context.store.state.currentTerminalInfo) {
        tobackend.getTerminal(context.store, theCookie).then(() => {
          if (!tobackend.checkCurrentRoute(context.store, context.route.path)) {
            return context.redirect(tobackend.getRoute(context.store))
          }
        })
      } else {
        if (!tobackend.checkCurrentRoute(context.store, context.route.path)) {
          return context.redirect(tobackend.getRoute(context.store))
        }
      }
      //getTerminalInfo based on CookieLink
    }
  }
}
