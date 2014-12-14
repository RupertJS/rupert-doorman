doorman = require('./auth/config.coffee')

authFailed = (req, res, next)->
    res.sendStatus 401

doorman.defaultAuthorizationFailed = (fn)->
    authFailed = fn

doorman.isLoggedIn = (req, res, next)->
    unless req.user
        return authFailed req, res, next
    next()

module.exports = doorman
