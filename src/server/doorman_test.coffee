doorman = require('./doorman')

describe 'Doorman', ->
    it 'provides `isLoggedIn` method', ->
        doorman.should.have.property('isLoggedIn')
        doorman.isLoggedIn.should.be.instanceof Function

        res = {
            status: -> {
                send: ->
            }
        }
        status = sinon.spy(res, 'status')
        next = sinon.spy()

        doorman.isLoggedIn({}, res, next)
        status.should.have.been.calledWith 401

        doorman.isLoggedIn({user: true}, res, next)
        next.should.have.been.called

    it 'allows overriding failure behavior', ->
        doorman.should.have.property('defaultAuthorizationFailed')
        doorman.defaultAuthorizationFailed.should.be.instanceof Function

        req = user: true
        res = sendStatus: sinon.spy()
        next = sinon.spy()

        doorman.defaultAuthorizationFailed (req, res, next)->
            res.sendStatus 403

        doorman.isLoggedIn({}, res, next)
        res.sendStatus.should.have.been.calledWith(403)
