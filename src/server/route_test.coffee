request = require('supertest')
express = require('express')
router = require('./route')
doorman = require('./doorman')

describe 'Doorman Router', ->
    it 'exports a routing function', ->
        router.should.be.an.instanceof Function

    it 'attaches express-session to the app', (done)->
        config = {}
        doorman(config)
        app = express()
        router(app, config)
        app.get '/route', (q, s, n)->
            q.should.have.property('session')
            s.send {status: 'ok'}
        request(app).get('/route').expect(200).end(done)
