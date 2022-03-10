const _ = require('lodash')
const pictureHasChanges = (original, tocheck) => {
    // no picture matching strategy determined. Todo?
    return true
}

const userHasChanges = (
    originalUser,
    updateObject,
    uGroupAllreadyLinked,
    classId
) => {
    if (originalUser.first_name !== updateObject.voornaam) {
        return true
    }
    if (originalUser.last_name !== updateObject.naam) {
        return true
    }
    if (originalUser.date_of_birth !== null && (originalUser.date_of_birth !== updateObject.geboortedatum)) {
        return true
    }

    if(originalUser.classgroup !== null && (originalUser.classgroup.id !== classId)){
        return true
    }

    // Check here? How to check?
    // if (originalUser.nulloriginalUser!== null && (originalUser.classgroup.id !== updateObject.klasnummer)) {
    //     return true
    // }

    if (originalUser.internal_number !== updateObject.internnummer) {
        return true
    }

    if (originalUser.smartschool_username !== updateObject.gebruikersnaam) {
        return true
    }

    // if (originalUser.picture.id !== updateObject.internal_number) {
    //     return true
    // }

    if (uGroupAllreadyLinked === false) {
        return true
    }

    return false
}

const coAccountHasChanges = (activeCoAccount, coAccountPropsTocheck, usersToCheck) => {

    // Do not update CoAccount based on these fields! 
    // Data not thrustworthy from Smartschool.
    // if (activeCoAccount.first_name !== coAccountPropsTocheck.first_name) {
    //     return true
    // }
    // if (activeCoAccount.last_name !== coAccountPropsTocheck.last_name) {
    //     return true
    // }

    // compare lower cases data contains upper and lower cased emails.
    if (activeCoAccount.email.toLowerCase().trim() !== coAccountPropsTocheck.email.toLowerCase().trim()) {
        return true
    }

    if (usersToCheck.length > 0) {
        const differentUsers = _.differenceWith(activeCoAccount.users, usersToCheck, (activeUser, userObj) => {
            return activeUser.id === userObj.id
        })

        if (differentUsers.length > 0) {
            return true
        }
    }

    return false
}


module.exports = {
    pictureHasChanges,
    userHasChanges,
    coAccountHasChanges
}