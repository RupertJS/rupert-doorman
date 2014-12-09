Path = require('path')

secret = do ->
    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
    -> (chars[Math.floor(Math.random() * chars.length)] for [0...24]).join('')

DoormanConfig = (config)->
    config.routes or= []
    config.routes.unshift Path.join __dirname, 'route.coffee'

    config.doorman or= {}

    config.doorman.session or= {}
    config.doorman.session.secret or= secret()
    config.doorman.session.resave or= false # The correct default
    config.doorman.session.saveUninitialized or= false # The correct default
    config.doorman.session.cookie or= {}
    config.doorman.session.cookie.secure = if config.tls then true else false

module.exports = DoormanConfig
