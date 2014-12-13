doorman = require('./config')

describe 'Doorman', ->
    it 'exports a function to configure', ->
        doorman.should.be.an.instanceof Function

    it 'configures the Rupert config with its route', ->
        config = {}
        doorman(config)
        config.routing.length.should.equal 1
        config.routing[0].should.match /src.server.auth.route\.coffee/

    it 'sets good session defaults', ->
        config = {}
        doorman(config)
        config.doorman.session.secret.length.should.equal 24
        config =
            doorman:
                session:
                    secret: "I'mma GREYLIEN!"
        doorman(config)
        config.doorman.session.secret.should.equal "I'mma GREYLIEN!"
        config.doorman.session.cookie.secure.should.equal false

    it 'configures oauth providers', ->
        config =
            hostname: 'example.com'
            doorman:
                providers:
                    oauth2:
                        authorizationURL:
                            'https://www.provider.com/oauth2/authorize'
                        tokenURL: 'https://www.provider.com/oauth2/token'
                        clientID: '123-456-789'
                        clientSecret: 'shhh-its-a-secret'

        doorman(config)

        config.doorman.providers.oauth2.should.have.property('callbackURL')
        config.doorman.providers.oauth2.callbackURL.should.equal(
            '/doorman/oauth2/callback'
        )
