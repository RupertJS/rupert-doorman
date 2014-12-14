doorman = require('./doorman')

describe 'Doorman', ->
    it 'provides `isLoggedIn` method', ->
        doorman.should.have.property('isLoggedIn')
        doorman.isLoggedIn.should.be.instanceof Function

        req = user: true
        res = sendStatus: sinon.spy()
        next = sinon.spy()

        doorman.isLoggedIn({}, res, next)
        res.sendStatus.should.have.been.calledWith(401)

        doorman.isLoggedIn(req, res, next)
        next.should.have.been.called
