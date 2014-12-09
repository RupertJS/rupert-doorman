session = require('express-session')
log = require('rupert/src/logger').log
passport = require('passport')
user = require('./storage')

DoormanRouter = (app, config)->
    app.use(session(config.doorman.session))

    for provider, providerConfig of config.doorman.providers
        try
            oauth2 = false
            if provider is 'oauth2'
                oauth2 = true
                provider = 'oauth'
            lib = require('passport-' + provider)

            Strategy =
                if provider is 'oauth'
                    if oauth2
                        lib.OAuth2Strategy
                    else
                        lib.OAuthStrategy
                else
                    lib.Strategy

            strategy = new Strategy providerConfig, user.Store
            passport.use provider, strategy

            app.get(
                "/doorman/#{provider}/connect"
                passport.authenticate provider
            )

            app.get(
                "/doorman/#{provider}/callback"
                passport.authenticate('provider',
                    successRedirect: '/'
                    failureRedirect: '/login'
                )
            )
        catch e
            console.log e
            log.warn 'Failed to connect authentication provider.'
            log.info e


module.exports = DoormanRouter
