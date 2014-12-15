describe 'Doorman Authorization', ->
    beforeEach module 'rupert.doorman.authorization'

    it 'exposes $authorization', inject ($authorization)->
        should.exist $authorization

    it 'exposes IsLoggedIn', inject (IsLoggedIn)->
        should.exist IsLoggedIn

    describe 'IsLoggedIn', ->
        it 'rejects on 401', inject (IsLoggedIn, $httpBackend)->
            $httpBackend.whenGET('/doorman').respond 401
            $httpBackend.expectGET '/doorman'
            isLoggedIn = IsLoggedIn()
            isLoggedIn.should.have.property 'then'
            err = null
            isLoggedIn.catch (e)-> err = e
            $httpBackend.flush()
            should.exist err

        it 'resolves on 200', inject (IsLoggedIn, $httpBackend)->
            $httpBackend.whenGET('/doorman').respond 200, {id: '123abc'}
            $httpBackend.expectGET '/doorman'
            isLoggedIn = IsLoggedIn()
            user = null
            isLoggedIn.then (u)-> user = u
            $httpBackend.flush()
            should.exist user
            user.should.have.property 'id'
            user.id.should.equal '123abc'

    describe 'oauth login flow', ->
        window =
            open: sinon.spy()

        beforeEach module ($provide)->
            $provide.value '$window', window
            return

        it 'opens a window for oauth login flow', inject ($authorization)->
            $authorization.connect 'test'
            window.open.should.have.been.calledWith '/doorman/test/connect'
