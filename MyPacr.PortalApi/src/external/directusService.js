var Directus = require('@directus/sdk')
var moment = require('moment')
const Promise = require('bluebird')
const config = require('config')
const { max } = require('lodash')

service = {
  settings: {
    url: null,
  },
}

client = {}

service.setupService = () => {
  const directusSettings = config.get('directusSettings')
  service.settings.url = directusSettings.url
  client = new Directus.Directus(directusSettings.url)
  return client.auth.static(directusSettings.token);
}

service.getGeneralSettings = () => {
  return new Promise((resolve, reject) => {
    client.items('globalsettings')
      .readByQuery({
        fields: '*,default_cardleasing_type.*,default_pricelevel.*',
      })
      .then((resp) => {
        console.log("Received general settings")
        console.log(resp)
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
    client.items('classgroup')
      .readByQuery({
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
    client.items('classgroup')
      .readByQuery({
        fields: '*',
        filter: {
          internal_number: {
            _eq: number,
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
    client.items('classgroup')
      .readByQuery({
        fields: '*',
        filter: {
          code: {
            _eq: code,
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
    client.items('classgroup')
      .createOne({
        internal_number: classgroup.id,
        code: classgroup.code,
        name: classgroup.name,
        description: classgroup.desc,
      })
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.updateClassGroup = (id, classgroup) => {
  return new Promise((resolve, reject) => {
    client.items('classgroup')
      .updateOne(id, {
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
    client.items('users')
      .readByQuery({
        fields:
          '*,picture.*,card_leasings.*,card_leasings.card.*,usergroup.*,usergroup.usergroups_id.*',
        filter: {
          internal_number: {
            _eq: internalNumber,
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
    client.items('users')
      .readByQuery({
        fields:
          '*,picture.*,card_leasings.*,card_leasings.card.*,usergroup.*,usergroup.usergroups_id.*',
        filter: {
          smartschool_username: {
            _eq: userName,
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
    client.items('users')
      .createOne({
        first_name: user.voornaam,
        last_name: user.naam,
        date_of_birth:
          user.geboortedatum == '0000-00-00' ? null : user.geboortedatum,
        internal_number: user.internnummer,
        smartschool_username: user.gebruikersnaam,
      })
      .then((resp) => {
        return resolve(resp)
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

    client.items('users')
      .updateOne(id, updateObject)
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
    client.items('users')
      .readByQuery({
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
    client.items('coaccounts')
      .readByQuery({
        fields: '*, users.*',
        filter: {
          email: {
            _eq: email,
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
    client.items('coaccounts')
      .readByQuery({
        fields: '*, users.*, allowed_card_leasings.*.*',
        filter: {
          email: {
            _in: emails,
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
    client.items('coaccounts')
      .readByQuery({
        fields: '*, users.*,users.users_id.*, allowed_card_leasings.*.*',
        filter: {
          'users.users_id.id': {
            _eq: userId,
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
    client.items('coaccounts')
      .readOne(id, {
        fields:
          '*.*.*,users.users_id.card_leasings.*.*.*.*.*,users.users_id.*,allowed_card_leasings.*.*',
      })
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.createCoAccount = (coAccount) => {
  return new Promise((resolve, reject) => {
    client.items('coaccounts')
      .createOne({
        email: coAccount.email,
        first_name: coAccount.first_name,
        last_name: coAccount.last_name,
        password: coAccount.password,
      })
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}
service.updateCoAccount = (coAccount, id, userObject) => {
  return new Promise((resolve, reject) => {
    client.items('coaccounts')
      .updateOne(id, {
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
    client.items('cards')
      .readByQuery({
        fields: '*',
        filter: {
          code: {
            _eq: code,
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
    client.items('cardleasings')
      .createOne({
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
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.linkUnknownCard = (cardCode, userId, leasingTypeId, fullDesc) => {
  return new Promise((resolve, reject) => {
    client.items('cards')
      .createOne({
        code: cardCode,

      })
      .then((resp) => {
        return client.items('cardleasings')
          .createOne({
            description: 'Import van oude Data',
            saldo: 0,
            active: true,
            from: moment().format('YYYY-MM-DD'),
            user: {
              id: userId,
            },
            card: {
              id: resp.id,
            },
            card_leasing_type: {
              id: leasingTypeId,
            },
            full_description: fullDesc,
          })
          .then((resp) => {
            return resolve(resp)
          })
          .catch((err) => {
            return reject(err)
          })
      })
  })
}

service.getAllCardTypes = () => {
  return new Promise((resolve, reject) => {
    client.items('card_leasing_type')
      .readByQuery({
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
    client.items('cardleasings')
      .readByQuery({
        fields:
          '*,user.*, card.*,,transactions.*, transactions.order.order_items.*.*,card_leasing_type.*',
        filter: {
          'user.id': {
            _eq: id,
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
    client.items('cardleasings')
      .readByQuery({
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
    client.items('cardleasings')
      .readByQuery({
        fields: '*,user.*, card.*,card_leasing_type.*',
        limit: -1,
        filter: {
          saldo: {
            _lte: treshold,
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
    client.items('transactions')
      .readByQuery({
        fields: '*, cardleasing.*',
        filter: {
          cardleasing: {
            id: {
              _eq: oldCardLeasingId,
            }
          },
        },
        limit: -1,
      })
      .then((resp) => {
        var transRay = []
        resp.data.forEach((element) => {
          transRay.push({
            id: element.id,
          })
        })
        if (transRay.length > 0) {
          return client.items('transactions').updateMany(transRay, {
            cardleasing: {
              id: newCardLeasingId,
            },
          });
        } else {
          return {
            data: null,
          }
        }
      })
      .then((resp) => {
        return client.items('cardleasings').updateOne(newCardLeasingId, {
          saldo: newSaldo
        })
      })
      .then((resp) => {
        return client.items('cardleasings').deleteOne(oldCardLeasingId);
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
    client.items('cardleasings')
      .updateOne(newId, {
        saldo: newSaldo,
      })
      .then((resp) => {
        return client.items('cardleasings').deleteOne(id)
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
    client.items('cardleasings')
      .updateOne(id, {
        saldo: saldo,
      })
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        return reject(err)
      })
  })
}

service.updateFullDescription = (id, fullDescription) => {
  return new Promise((resolve, reject) => {
    client.items('cardleasings')
      .updateOne(id, {
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
    client.files
      .updateOne(id, {
        data: pictureObject
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
    client.files
      .createOne({
        pictureObject
      })
      .then((resp) => {
        return resolve(resp)
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
    client.items('usergroups')
      .readByQuery({
        limit: -1,
      })
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
    console.log(payload);
    client.items('online_payment')
      .createOne({
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
        return resolve(resp)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getOnlinePaymentById = (id) => {
  return new Promise((resolve, reject) => {
    client.items('online_payment')
      .readOne(id, {
        fields: '*.*.*.*',
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

service.completeOnlinePayment = (id, refunded) => {
  return new Promise((resolve, reject) => {
    client.items('online_payment')
      .updateOne(id, {
        completed: true,
        handling_fee_refunded: refunded,
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

service.completeOnlineTopOff = (id) => {
  return new Promise((resolve, reject) => {
    client.items('online_topoff')
      .updateOne(id, {
        completed: true,
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

//#endregion

//#region transactions

service.createTransaction = (object) => {
  return new Promise((resolve, reject) => {
    client.items('transactions')
      .createOne(object)
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

//#endregion

service.getAllOrderItems = () => {
  return new Promise((resolve, reject) => {
    client.items('orderitems')
      .readByQuery({
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
    client.items('orders')
      .readByQuery({
        fields: '*, transactions.*',
        limit: -1,
        filter: {
          created_on: {
            _between: [from, until],
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
    client.items('orderitems')
      .updateOne(orderItemId, {
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
    client.items('transactions')
      .deleteMany(idRay)
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
    client.items('transactions')
      .createMany(transRay)
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
    client.items('attendenceprofile')
      .readByQuery({
        fields: '*.*',
        filter: {
          user: {
            id: {
              _in: userIds,
            }
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
    client.items('attendenceprofile')
      .readByQuery({
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
      client.items('attendenceprofile')
        .updateOne(attendenceProfile.id, {
          attendenceProfile,
        })
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
      client.items('attendenceprofile')
        .createOne(attendenceProfile)
        .then((resp) => {
          return resolve(resp)
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
      cardleasing: {
        id: {
          _eq: cardLeasingId,
        }
      },
    }
    paramObject.fields = '*,order.*.*.*'
    paramObject.sort = 'time_of_transaction'

    client.items('transactions')
      .readByQuery(paramObject)
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
      cardleasing: {
        id: {
          _eq: cardLeasingId,
        }
      },
    }
    paramObject.fields = '*'
    paramObject.sort = 'time_of_transaction'

    client.items('transactions')
      .readByQuery(paramObject)
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
        _lte: currentDate,
      },
      till: {
        _gte: currentDate,
      },
    }

    client.items('attendence_exceptions')
      .readByQuery(paramObject)
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
    client.items('attendences')
      .readByQuery({
        fields: '*',
        filter: {
          user: {
            _eq: userId,
          },
          date: {
            _eq: currentDate,
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
    client.items('absences')
      .createOne(absence)
      .then((resp) => {
        return resolve(resp)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

service.getAbsencesForUserByDate = (userId, currentDate) => {
  return new Promise((resolve, reject) => {
    client.items('absences')
      .readByQuery({
        fields: '*',
        filter: {
          user: {
            _eq: userId,
          },
          date_of_absence: {
            _eq: currentDate,
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
    client.items('controles')
      .readByQuery({
        limit: -1
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

service.getControleExceptionsForCurrentDay = (currentDate) => {
  return new Promise((resolve, reject) => {
    var paramObject = {}
    paramObject.fields = '*'
    paramObject.filter = {
      from: {
        _lte: currentDate,
      },
      till: {
        _gte: currentDate,
      },
    }

    client.items('controle_exceptions')
      .readByQuery(paramObject)
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
    client.items('reports')
      .readByQuery({
        single: true,
        fields: '*',
        filter: {
          key: {
            _eq: key,
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
    client.items('z_configurations')
      .readByQuery({
        fields: '*',
      })
      .then((resp) => {
        console.log('Retrieved Directus configurations')
        console.log(resp)
        return resolve(resp.data)
      })
      .catch((err) => {
        console.log(err)
        return reject(err)
      })
  })
}

module.exports = service
