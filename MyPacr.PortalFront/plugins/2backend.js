const Promise = require('bluebird')
const axios = require('axios')

const service = {
  url: process.env.apiUrl
}

service.getMe = () => {}

service.isLoggedIn = store => {
  return store.state.loginObject != null
}

service.logOut = store => {
  store.commit('setLoginObject', null)
}

service.initiatePayment = (payload, token) => {
  return new Promise((resolve, reject) => {
    axios
      .post(service.url + '/paymentInternal/generatePayment', payload, {
        headers: {
          'x-auth': token
        }
      })
      .then(resp => {
        return resolve(resp.data.url)
      })
      .catch(err => {
        return reject(err)
      })
  })
}

service.getAttendenceProfiles = store => {
  return new Promise((resolve, reject) => {
    //generate userId array  
    var userIds = []
    store.state.loginObject.FullAccount.users.forEach(element => {
      userIds.push(element.users_id.id)
    })
    //do the call
    axios
      .post(
        service.url + '/attendences/getAttendenceProfiles', {
          userIds: userIds,
          email: store.state.loginObject.FullAccount.email
        }, {
          headers: {
            'x-auth': store.state.loginObject.token
          }
        }
      )
      .then(resp => {
        store.commit('setAttendenceProfiles', resp.data)
        return resolve(true)
      })
      .catch(err => {
        return reject(err)
      })

    //store the data in the store
  })
}

service.saveAttendenceProfile = (store, attendenceProfile) => {
  return new Promise((resolve, reject) => {
    axios
      .post(
        service.url + '/attendences/saveAttendenceProfile', {
          attendenceProfile: attendenceProfile,
          email: store.state.loginObject.FullAccount.email
        }, {
          headers: {
            'x-auth': store.state.loginObject.token
          }
        }
      )
      .then(resp => {
        return resolve(true)
      })
      .catch(err => {
        return reject(err)
      })
  })
}

service.getPagedTransactions = (store, itemsPerPage, pageNumber, id) => {
  return new Promise((resolve, reject) => {
    axios
      .post(
        service.url + '/transactions/getTransactionsPaginated', {
          email: store.state.loginObject.FullAccount.email,
          limit: itemsPerPage,
          pageNumber: pageNumber,
          cardLeasingId: id
        }, {
          headers: {
            'x-auth': store.state.loginObject.token
          }
        }
      )
      .then(resp => {
        return resolve(resp.data)
      })
      .catch(err => {
        return reject(err)
      })
  })
}

service.getTransactionsCount = (store, id) => {
  return new Promise((resolve, reject) => {
    axios
      .post(
        service.url + '/transactions/getTransactionsCount', {
          email: store.state.loginObject.FullAccount.email,
          cardLeasingId: id
        }, {
          headers: {
            'x-auth': store.state.loginObject.token
          }
        }
      )
      .then(resp => {
        return resolve(resp.data)
      })
      .catch(err => {
        return reject(err)
      })
  })
}

service.registerOwn = (store, account) => {
  return new Promise((resolve, reject) => {
    axios
      .post(
        service.url + '/user/register', {
          account: account
        },
      )
      .then(resp => {
        return resolve(resp.data)
      })
      .catch(err => {
        return reject(err)
      })

  })
}


service.authenticateOwn = (store, user) => {
  return new Promise((resolve, reject) => {
    axios
      .post(
        service.url + '/user/authenticate', {
          email: user.email,
          password: user.password,
        },
      )
      .then(resp => {
        return resolve(resp.data)
      })
      .catch(err => {
        return reject(err)
      })

  })
}

service.getAuthProviderSettings = (store) => {
  return new Promise((resolve, reject) => {
    axios
      .post(
        service.url + '/user/authProviderSettings'
      )
      .then(resp => {
        return resolve(resp.data)
      })
      .catch(err => {
        return reject(err)
      })

  })

}

export default service