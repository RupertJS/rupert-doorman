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

    it 'loads oath provider routes', (done)->
        config =
            name: 'doorman-test'
            stassets: no
            websockets: no
            static: no
            doorman:
                providers:
                    oauth2:
                        authorizationURL:
                            'https://www.provider.com/oauth2/authorize'
                        tokenURL: 'https://www.provider.com/oauth2/token'
                        clientID: '123-456-789'
                        clientSecret: 'shhh-its-a-secret'

        doorman(config)
        require('rupert')(config).then ({app})->
            request(app)
                .get('/doorman/oauth/connect')
                .expect(302)
                .end done
