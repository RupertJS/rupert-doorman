doorman = require('./config')
Config = require('rupert').config

describe 'Doorman', ->
    it 'exports a function to configure', ->
        doorman.should.be.an.instanceof Function

    it 'configures the Rupert config with its route', ->
        config = {}
        config = doorman(config)
        config.routing.length.should.equal 1
        config.routing[0].should.match /src.server.auth.route\.coffee/

    it 'sets good session defaults', ->
        config = {}
        config = doorman(config)
        config.doorman.session.secret.length.should.equal 24
        config =
            doorman:
                session:
                    secret: "I'mma GREYLIEN!"
        doorman(config)
        config.doorman.session.secret.should.equal "I'mma GREYLIEN!"
        config.doorman.session.cookie.secure.should.equal false
