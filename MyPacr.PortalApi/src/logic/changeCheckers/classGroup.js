const hasChanges = (original, tocheck) => {
    if (original.code !== tocheck.code) {
        return true
    }

    if (original.name !== tocheck.name) {
        return true
    }

    if (original.description !== tocheck.desc) {
        return true
    }

    return false
}

module.exports = {hasChanges}