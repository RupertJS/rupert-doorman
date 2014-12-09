doorman = require('./doorman.js')

describe 'Doorman', ->
    it 'exports a function to configure', ->
        doorman.should.be.an.instanceof Function

    it 'configures the Rupert config with its route', ->
        config = {}
        doorman(config)
        config.routes.length.should.equal 1
        config.routes[0].should.match /rupert-doorman.src.server.route\.coffee/
