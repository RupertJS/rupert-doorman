session = require('express-session')
logger = require('rupert/src/logger')
passport = require('passport')
user = require('./storage')

authed = (req, res, next)->
    # Nothing has failed? Nothing has redirected?
    res.sendStatus 204

attach = (name, config, app)->
    oauth2 = false
    if name is 'oauth2'
        oauth2 = true
        name = 'oauth'

    providerLib = config.libPath or "passport-#{name}"
    lib = require(providerLib)

    Strategy =
        if name is 'oauth'
            if oauth2
                lib.OAuth2Strategy
            else
                lib.OAuthStrategy
        else
            lib.Strategy

    strategy = new Strategy config, user.wrapStore user.Store
    passport.use name, strategy

    # Magic happens in how the Strategy uses these endpoints.
    [
        'connect'
        'callback'
    ].concat(config.endpoints or []).forEach (_)->
        app.get "/doorman/#{name}/#{_}", passport.authenticate(name), authed

DoormanRouter = (app, config)->
    app.use(session(config.doorman.session))
    app.use(passport.initialize())
    app.use(passport.session())

    users = {}
    passport.serializeUser (user, done)->
        users[user.id] = user
        done(null, user.id)
    passport.deserializeUser (id, done)->
        user = users[id]
        done(null, user)

    for provider, providerConfig of config.doorman.providers
        try
            attach provider, providerConfig, app
        catch e
            logger.log.warn 'Failed to connect authentication provider.'
            logger.log.info e

    app.get '/doorman', (req, res, next)->
        if req.user
            user = JSON.parse JSON.stringify req.user
            delete user.tokens
            res.send user
        else
            res.sendStatus 401

module.exports = DoormanRouter
