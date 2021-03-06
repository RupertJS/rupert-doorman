doorman = require('./config')
Config = require('rupert').Config

describe 'Doorman', ->
    it 'exports a function to configure', ->
        doorman.should.be.an.instanceof Function

    it 'configures the Rupert config with its route', ->
        config = new Config {}
        doorman(config)
        config.routing.length.should.equal 1
        config.routing[0].should.match /src.server.auth.route\.js/

    it 'sets good session defaults', ->
        config = new Config {}
        doorman(config)
        config.doorman.session.secret.length.should.equal 24
        config = new Config
            doorman:
                session:
                    secret: "I'mma GREYLIEN!"
        doorman(config)
        # config.doorman.session.secret.should.equal "I'mma GREYLIEN!"
        config.doorman.session.cookie.secure.should.equal false
