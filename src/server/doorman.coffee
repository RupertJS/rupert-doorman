doorman = require('./auth/config.coffee')

doorman.isLoggedIn = (req, res, next)->
    unless req.user
        return res.sendStatus 401
    next()

module.exports = doorman
