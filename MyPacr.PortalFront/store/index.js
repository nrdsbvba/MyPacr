export const state = () => {
  return {
    loginObject: null,
    loginError: false,
    loginMessage: '',
    attendenceProfiles: [],
    mobileNavShowing: null,
    authProviderSettings: null
  }
}

export const mutations = {
  setLoginObject(state, loginObject) {
    state.loginObject = loginObject
  },
  setLoginError(state, loginError) {
    state.loginError = loginError
  },
  setLoginMessage(state, loginMessage) {
    state.loginMessage = loginMessage
  },
  setAttendenceProfiles(state, attendenceProfiles) {
    state.attendenceProfiles = attendenceProfiles
  },
  setMobileNavShowing(state, mobileNavShowing) {
    state.mobileNavShowing = mobileNavShowing
  },
  setAuthProviderSettings(state, authProviderSettings) {
    state.authProviderSettings = authProviderSettings
  }
}

export const actions = {}