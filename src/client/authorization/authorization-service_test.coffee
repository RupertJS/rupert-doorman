describe 'Doorman Authorization', ->
    beforeEach module 'rupert.doorman.authorization'

    it 'exposes $authorization', inject ($authorization)->
        should.exist $authorization

    it 'exposes IsLoggedIn', inject (IsLoggedIn)->
        should.exist IsLoggedIn

    describe 'oauth login flow', ->
        window =
            open: sinon.spy()

        beforeEach module ($provide)->
            $provide.value '$window', window
            return

        it 'opens a window for oauth login flow', inject ($authorization)->
            $authorization.connect 'test'
            window.open.should.have.been.calledWith '/doorman/test/connect'
