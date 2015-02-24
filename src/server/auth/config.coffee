Path = require('path')

secret = do ->
    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
    -> (chars[Math.floor(Math.random() * chars.length)] for [0...24]).join('')

DoormanConfig = (config)->
    route = Path.join __dirname, 'route.coffee'
    config.prepend 'routing', Path.relative process.cwd(), route

    config.find 'doorman.session.secret', 'SESSION_SECRET', secret()
    # The correct defaults
    config.find 'doorman.session.resave', false
    config.find 'doorman.session.saveUninitialized', false

    secure = if config.tls then true else false
    config.find 'doorman.session.cookie.secure', secure

module.exports = DoormanConfig
