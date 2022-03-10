const Promise = require('bluebird')

const updateIfChanges = (checkChangesProcess, updateProcess) => {
    return new Promise((resolve, reject) => {
        let checkRes = checkChangesProcess()
        if (checkRes === true) {
            updateProcess()
                .then(data => {
                    return resolve(data)
                })
        } else {
            return resolve(true)
        }
    })
}

module.exports = {
    updateIfChanges
}