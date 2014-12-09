Path = require('path')

secret = do ->
    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
    -> (chars[Math.floor(Math.random() * chars.length)] for [0...24]).join('')

DoormanConfig = (config)->
    config.routing or= []

    route = Path.join __dirname, 'route.coffee'
    config.routing.unshift Path.relative process.cwd(), route

    config.doorman or= {}

    config.doorman.session or= {}
    config.doorman.session.secret or= secret()
    config.doorman.session.resave or= false # The correct default
    config.doorman.session.saveUninitialized or= false # The correct default
    config.doorman.session.cookie or= {}
    config.doorman.session.cookie.secure = if config.tls then true else false

    for provider, providerConfig of config.doorman.providers
        providerConfig.callbackURL = # Need APP_URL from Rupert :/
            "/doorman/#{provider}/callback"

module.exports = DoormanConfig
