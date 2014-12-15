request = require('supertest')
express = require('express')
router = require('./route')
doorman = require('./config')

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

    it 'completes a login', (done)->
        config =
            name: 'doorman-test'
            stassets: no
            websockets: no
            static: no
            doorman:
                providers:
                    test:
                        libPath: './test_strategy'

        doorman(config)
        require('rupert')(config).then ({app})->
            connect = request(app)
                .get('/doorman/test/connect')
                .expect(302)

            callback = request(app)
                .get('/doorman/test/callback')
                .query({code: 'loggedin'})
                .expect(204)

            connect.end (err)->
                return done(err) if err
                callback.end (err, res)->
                    done(err)

    it 'returns user info on request', (done)->
        config =
            name: 'doorman-test'
            stassets: no
            websockets: no
            static: no
            doorman:
                providers:
                    test:
                        libPath: './test_strategy'
        doorman(config)
        require('rupert')(config).then ({app})->
            agent = request.agent(app)

            agent
            .get('/doorman')
            .expect(401)
            .end (err)->
                return done(err) if err
                agent
                .get('/doorman/test/callback')
                .query({code: 'loggedin'})
                .expect(204)
                .end (err, res)->
                    return done(err) if err
                    agent
                    .get('/doorman')
                    .expect(200).end (err, res)->
                        return done(err) if err
                        res.body.should.not.have.property 'test'
                        res.body.should.not.have.property 'tokens'
                        res.body.id.should.equal '123abc'
                        done()
