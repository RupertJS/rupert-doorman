doorman = require('./doorman.js')

describe 'Doorman', ->
    it 'exports a function to configure', ->
        doorman.should.be.an.instanceof Function
