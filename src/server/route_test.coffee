router = require('./route')

describe 'Doorman Router', ->
    it 'exports a routing function', ->
        router.should.be.an.instanceof Function
