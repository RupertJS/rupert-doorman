session = require('express-session')
logger = require('rupert/src/logger')
passport = require('passport')
user = require('./storage')

authed = (req, res, next)->
    # Nothing has failed? Nothing has redirected?
    res.sendStatus 204

name = 'Rupert Doorman App'
close = (req, res, next)->
    res.send """<html>
        <head><title>#{name}</title></head>
        <body><script>window.close();</script></body>
        </html>"""

attach = (name, config, app, base)->

    oauth2 = false
    if name is 'oauth2'
        oauth2 = true
        config.libPath = 'passport-oauth'
    if config.returnURL or config.realm
        # Assume OAuth
        oauth2 = false
    if name is 'google' # Old passport-google library is deprecated
        config.libPath = 'passport-google-oauth'
    if config.clientID and config.clientSecret
        oauth2 = true

    providerLib = config.libPath or "passport-#{name}"
    lib = require(providerLib)

    Strategy =
        if oauth2 and lib.OAuth2Strategy
            lib.OAuth2Strategy
        else if lib.OAuthStrategy
            lib.OAuthStrategy
        else
            lib.Strategy

    strategy = new Strategy config, user.wrapStore user.Store
    passport.use name, strategy

    # Magic happens in how the Strategy uses these endpoints.

    app.get "/#{base}/#{name}/connect", passport.authenticate(name)
    app.get "/#{base}/#{name}/callback", passport.authenticate(name), close

DoormanRouter = (app, config)->
    config.doorman.base or= 'doorman'
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
            attach provider, providerConfig, app, config.doorman.base
        catch e
            logger.log.warn 'Failed to connect authentication provider.'
            logger.log.info e.stack

    app.get "/#{config.doorman.base}", (req, res, next)->
        if req.user
            user = JSON.parse JSON.stringify req.user
            delete user.tokens
            res.send user
        else
            res.sendStatus 401

module.exports = DoormanRouter
