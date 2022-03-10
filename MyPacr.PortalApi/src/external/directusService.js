var DirectusSDK = require('@directus/sdk-js')
var moment = require('moment')
const Promise = require('bluebird')
const config = require('config')

service = {
  settings: {
    url: null,
  },
}

client = {}

service.setupService = () => {
  const directusSettings = config.get('directusSettings')
  service.settings.url = directusSettings.url
  client = new DirectusSDK(directusSettings)
}

service.getGeneralSettings = () => {
  return new Promise((resolve, reject) => {
    client
      .getItems('globalsettings', {
        fields: '*,default_cardleasing_type.*,default_pricelevel.*',
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

//#region  Classgroups
service.getAllClassGroups = (number) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('classgroup', {
        fields: '*',
        limit: -1,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.getClassGroupByInternalNumber = (number) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('classgroup', {
        fields: '*',
        filter: {
          internal_number: {
            eq: number,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.getClassGroupByCode = (code) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('classgroup', {
        fields: '*',
        filter: {
          code: {
            eq: code,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.createClassGroup = (classgroup) => {
  return new Promise((resolve, reject) => {
    client
      .createItem('classgroup', {
        internal_number: classgroup.id,
        code: classgroup.code,
        name: classgroup.name,
        description: classgroup.desc,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.updateClassGroup = (id, classgroup) => {
  return new Promise((resolve, reject) => {
    client
      .updateItem('classgroup', id, {
        code: classgroup.code,
        name: classgroup.name,
        description: classgroup.desc,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
//#endregion

//#region  Users
service.getUserByInternalNumber = (internalNumber) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('users', {
        fields:
          '*,picture.*,card_leasings.*,card_leasings.card.*,usergroup.*,usergroup.usergroups_id.*',
        filter: {
          internal_number: {
            eq: internalNumber,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.getUserByUserName = (userName) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('users', {
        fields:
          '*,picture.*,card_leasings.*,card_leasings.card.*,usergroup.*,usergroup.usergroups_id.*',
        filter: {
          smartschool_username: {
            eq: userName,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.createMinimalUser = (user) => {
  return new Promise((resolve, reject) => {
    client
      .createItem('users', {
        first_name: user.voornaam,
        last_name: user.naam,
        date_of_birth:
          user.geboortedatum == '0000-00-00' ? null : user.geboortedatum,
        internal_number: user.internnummer,
        smartschool_username: user.gebruikersnaam,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.updateUser = (
  id,
  user,
  classId,
  pictureId,
  userGroups,
  uGroupAllreadyLinked
) => {
  return new Promise((resolve, reject) => {
    var updateObject = {
      first_name: user.voornaam,
      last_name: user.naam,
      date_of_birth:
        user.geboortedatum == '0000-00-00' ? null : user.geboortedatum,
      classgroup: classId
        ? {
            id: classId,
          }
        : null,
      internal_number: user.internnummer,
      smartschool_username: user.gebruikersnaam,
      picture: pictureId
        ? {
            id: pictureId,
          }
        : null,
    }
    if (!uGroupAllreadyLinked) {
      updateObject.usergroup = userGroups
    }

    client
      .updateItem('users', id, updateObject)
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getAllUsers = () => {
  //get all users (minimal, no related objects)
  return new Promise((resolve, reject) => {
    client
      .getItems('users', {
        fields: '*',
        limit: -1,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
//#endregion

//#region  Co Accounts
service.getCoAccountByEmail = (email) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('coaccounts', {
        fields: '*, users.*',
        filter: {
          email: {
            eq: email,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getCoAccountsByEmail = (emails) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('coaccounts', {
        fields: '*, users.*, allowed_card_leasings.*.*',
        filter: {
          email: {
            in: emails,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getCoAccountsForUserById = (userId) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('coaccounts', {
        fields: '*, users.*,users.users_id.*, allowed_card_leasings.*.*',
        filter: {
          'users.users_id.id': {
            eq: userId,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getCoAccountById = (id) => {
  return new Promise((resolve, reject) => {
    client
      .getItem('coaccounts', id, {
        fields:
          '*.*.*,users.users_id.card_leasings.*.*.*.*.*,users.users_id.*,allowed_card_leasings.*.*',
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.createCoAccount = (coAccount) => {
  return new Promise((resolve, reject) => {
    client
      .createItem('coaccounts', {
        email: coAccount.email,
        first_name: coAccount.first_name,
        last_name: coAccount.last_name,
        password: coAccount.password,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.updateCoAccount = (coAccount, id, userObject) => {
  return new Promise((resolve, reject) => {
    client
      .updateItem('coaccounts', id, {
        email: coAccount.email,
        first_name: coAccount.first_name,
        last_name: coAccount.last_name,
        users: userObject,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
//#endregion

//#region  Cards
service.getCardByCode = (code) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('cards', {
        fields: '*',
        filter: {
          code: {
            eq: code,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.linkExisitngCard = (cardId, userId, leasingTypeId, fullDesc) => {
  return new Promise((resolve, reject) => {
    client
      .createItem('cardleasings', {
        description: 'Import van oude Data',
        saldo: 0,
        active: true,
        from: moment().format('YYYY-MM-DD'),
        user: {
          id: userId,
        },
        card: {
          id: cardId,
        },
        card_leasing_type: {
          id: leasingTypeId,
        },
        full_description: fullDesc,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.linkUnknownCard = (cardCode, userId, leasingTypeId, fullDesc) => {
  return new Promise((resolve, reject) => {
    client
      .createItem('cards', {
        code: cardCode,
      })
      .then((resp) => {
        return client
          .createItem('cardleasings', {
            description: 'Import van oude Data',
            saldo: 0,
            active: true,
            from: moment().format('YYYY-MM-DD'),
            user: {
              id: userId,
            },
            card: {
              id: resp.data.id,
            },
            card_leasing_type: {
              id: leasingTypeId,
            },
            full_description: fullDesc,
          })
          .then((resp) => {
            return resolve(resp.data)
          })
          .catch((err) => {
            return reject(err)
          })
      })
  })
}

service.getAllCardTypes = () => {
  return new Promise((resolve, reject) => {
    client
      .getItems('card_leasing_type', {
        fields: '*',
        limit: -1,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getAllCardLeasesByUserId = (id) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('cardleasings', {
        fields:
          '*,user.*, card.*,,transactions.*, transactions.order.order_items.*.*,card_leasing_type.*',
        filter: {
          'user.id': {
            eq: id,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getAllCardLeases = () => {
  return new Promise((resolve, reject) => {
    client
      .getItems('cardleasings', {
        fields:
          '*,user.*, card.*,transactions.*, transactions.order.order_items.*.*,card_leasing_type.*',
        limit: -1,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.getCardLeasingsUnderTreshold = (treshold) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('cardleasings', {
        fields: '*,user.*, card.*,card_leasing_type.*',
        limit: -1,
        filter: {
          saldo: {
            lte: treshold,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.doCardMerge = (oldCardLeasingId, newCardLeasingId, newSaldo) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('transactions', {
        fields: '*, cardleasing.*',
        filter: {
          'cardleasing.id': {
            eq: oldCardLeasingId,
          },
        },
        limit: -1,
      })
      .then((resp) => {
        var transRay = []
        resp.data.forEach((element) => {
          transRay.push({
            id: element.id,
            cardleasing: {
              id: newCardLeasingId,
            },
          })
        })
        if (transRay.length > 0) {
          return client.updateItems('transactions', transRay)
        } else {
          return {
            data: null,
          }
        }
      })
      .then((resp) => {
        return client.updateItem('cardleasings', newCardLeasingId, {
          saldo: newSaldo,
        })
      })
      .then((resp) => {
        return client.deleteItem('cardleasings', oldCardLeasingId)
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.hardDeleteCardLeasing = (oldId, newId, newSaldo) => {
  return new Promise((resolve, rejec) => {
    client
      .updateItem('cardleasings', newId, {
        saldo: newSaldo,
      })
      .then((resp) => {
        return client.deleteItem('cardleasings', id)
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.updateSaldo = (id, saldo) => {
  return new Promise((resolve, reject) => {
    client
      .updateItem('cardleasings', id, {
        saldo: saldo,
      })
      .then((resp) => {
        // console.log(resp)
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.updateFullDescription = (id, fullDescription) => {
  return new Promise((resolve, reject) => {
    client
      .updateItem('cardleasings', id, {
        full_description: fullDescription,
      })
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
//#endregion

//#region  files
service.updateImage = (id, pictureObject) => {
  return new Promise((resolve, reject) => {
    client
      .patch(service.settings.url + '/_/files/' + id, {
        data: pictureObject.data,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
      })
  })
}

service.createImage = (pictureObject) => {
  return new Promise((resolve, reject) => {
    client
      .post(service.settings.url + '/_/files', pictureObject)
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
      })
  })
}
//#endregion

//#region usergroups
service.getUserGroups = () => {
  return new Promise((resolve, reject) => {
    client
      .getItems('usergroups')
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
      })
  })
}
//#endregion

//#region online payments

service.createOnlinePayment = (payload) => {
  return new Promise((resolve, reject) => {
    client
      .createItem('online_payment', {
        coaccount: {
          id: payload.coaccount_id,
        },
        completed: false,
        handling_fee: payload.handling_fee,
        top_offs: payload.top_offs,
        time_of_payment: payload.time_of_payment,
        time_of_payment_with_offset: payload.time_of_payment_with_offset,
        time_of_payment_localized: payload.time_of_payment_localized,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getOnlinePaymentById = (id) => {
  return new Promise((resolve, reject) => {
    client
      .getItem('online_payment', id, {
        fields: '*.*.*.*',
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.completeOnlinePayment = (id, refunded) => {
  return new Promise((resolve, reject) => {
    client
      .updateItem('online_payment', id, {
        completed: true,
        handling_fee_refunded: refunded,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.completeOnlineTopOff = (id) => {
  return new Promise((resolve, reject) => {
    client
      .updateItem('online_topoff', id, {
        completed: true,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

//#endregion

//#region transactions

service.createTransaction = (object) => {
  return new Promise((resolve, reject) => {
    client
      .createItem('transactions', object)
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

//#enregion

service.getAllOrderItems = () => {
  return new Promise((resolve, reject) => {
    client
      .getItems('orderitems', {
        limit: -1,
        fields: '*',
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getOrderByDate = (datetime) => {
  return new Promise((resolve, reject) => {
    let from = moment(datetime)
      .subtract(1, 'seconds')
      .format('YYYY-MM-DD HH:mm:ss')
    let until = moment(datetime).add(0, 'seconds').format('YYYY-MM-DD HH:mm:ss')
    client
      .getItems('orders', {
        fields: '*, transactions.*',
        limit: -1,
        filter: {
          created_on: {
            between: [from, until],
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.fixOrderItem = (orderItemId, orderId) => {
  return new Promise((resolve, reject) => {
    client
      .updateItem('orderitems', orderItemId, {
        order: {
          id: orderId,
        },
      })
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.deleteTransactions = (idRay) => {
  return new Promise((resolve, reject) => {
    client
      .deleteItems('transactions', idRay)
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.createTransactions = (transRay) => {
  return new Promise((resolve, reject) => {
    client
      .createItems('transactions', transRay)
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getAttendenceProfiles = (userIds) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('attendenceprofile', {
        fields: '*.*',
        filter: {
          'user.id': {
            in: userIds,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getAllAttendenceProfiles = () => {
  return new Promise((resolve, reject) => {
    client
      .getItems('attendenceprofile', {
        fields: '*.*',
        limit: -1,
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.saveAttendenceProfile = (attendenceProfile) => {
  if (attendenceProfile.id != null && attendenceProfile.id > 0) {
    return new Promise((resolve, reject) => {
      client
        .updateItem(
          'attendenceprofile',
          attendenceProfile.id,
          attendenceProfile
        )
        .then((resp) => {
          return resolve(resp.data)
        })
        .catch((err) => {
          console.log(err)
          return reject(err)
        })
    })
  } else {
    return new Promise((resolve, reject) => {
      client
        .createItem('attendenceprofile', attendenceProfile)
        .then((resp) => {
          return resolve(resp.data)
        })
        .catch((err) => {
          console.log(err)
          return reject(err)
        })
    })
  }
}

service.getPagedTransactions = (limit, pageNumber, cardLeasingId) => {
  return new Promise((resolve, reject) => {
    var paramObject = {}
    paramObject.limit = limit > 0 ? limit : -1
    if (pageNumber && pageNumber > 0) {
      paramObject.offset = (pageNumber - 1) * limit
    }
    paramObject.filter = {
      'cardleasing.id': {
        eq: cardLeasingId,
      },
    }
    paramObject.fields = '*,order.*.*.*'
    paramObject.sort = 'time_of_transaction'

    client
      .getItems('transactions', paramObject)
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}
service.getTransactionsCount = (cardLeasingId) => {
  return new Promise((resolve, reject) => {
    var paramObject = {}
    paramObject.filter = {
      'cardleasing.id': {
        eq: cardLeasingId,
      },
    }
    paramObject.fields = '*'
    paramObject.sort = 'time_of_transaction'

    client
      .getItems('transactions', paramObject)
      .then((resp) => {
        return resolve(resp.data.length)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getAttendenceExceptionsForCurrentDay = (currentDate) => {
  return new Promise((resolve, reject) => {
    var paramObject = {}
    paramObject.fields = '*'
    paramObject.filter = {
      from: {
        lte: currentDate,
      },
      till: {
        gte: currentDate,
      },
    }

    client
      .getItems('attendence_exceptions', paramObject)
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getAttendencesForUserByDate = (userId, currentDate) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('attendences', {
        fields: '*',
        filter: {
          user: {
            eq: userId,
          },
          date: {
            eq: currentDate,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.saveAbsence = (absence) => {
  return new Promise((resolve, reject) => {
    client
      .createItem('absences', absence)
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getAbsencesForUserByDate = (userId, currentDate) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('absences', {
        fields: '*',
        filter: {
          user: {
            eq: userId,
          },
          date_of_absence: {
            eq: currentDate,
          },
        },
      })
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getAllControles = () => {
  return new Promise((resolve, reject) => {
    client
      .getItems('controles')
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getControleExceptionsForCurrentDay = (currentDate) => {
  return new Promise((resolve, reject) => {
    var paramObject = {}
    paramObject.fields = '*'
    paramObject.filter = {
      from: {
        lte: currentDate,
      },
      till: {
        gte: currentDate,
      },
    }

    client
      .getItems('controle_exceptions', paramObject)
      .then((resp) => {
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getReportByKey = (key) => {
  return new Promise((resolve, reject) => {
    client
      .getItems('reports', {
        single: true,
        fields: '*',
        filter: {
          key: {
            eq: key,
          },
        },
      })
      .then((resp) => {
        console.log(resp.data)
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getConfigurations = () => {
  return new Promise((resolve, reject) => {
    client
      .getItems('z_configurations', {
        fields: '*',
      })
      .then((resp) => {
        console.log('Retrieved Directus configurations')
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

module.exports = service
