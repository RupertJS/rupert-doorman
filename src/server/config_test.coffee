doorman = require('./doorman.js')

describe 'Doorman', ->
    it 'exports a function to configure', ->
        doorman.should.be.an.instanceof Function

    it 'configures the Rupert config with its route', ->
        config = {}
        doorman(config)
        config.routes.length.should.equal 1
        config.routes[0].should.match /rupert-doorman.src.server.route\.coffee/

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
