describe 'Doorman Authorization', ->
    beforeEach module 'rupert.doorman.authorization'

    it 'exposes $authorization', inject ($authorization)->
        should.exist $authorization

    it 'exposes IsLoggedIn', inject (IsLoggedIn)->
        should.exist IsLoggedIn

    describe 'IsLoggedIn', ->
        $httpBackend = null
        $rootScope = null
        SUT = null
        beforeEach inject ($injector)->
            $httpBackend = $injector.get '$httpBackend'
            $rootScope = $injector.get '$rootScope'
            SUT = $injector.get('IsLoggedIn')

        authResponse = null
        beforeEach ->
            authResponse = $httpBackend.whenGET('/doorman')
                .respond 200, {id: '123abc'}
            $httpBackend.expectGET '/doorman'

        afterEach ->
            $httpBackend.verifyNoOutstandingRequest()
            $httpBackend.verifyNoOutstandingExpectation()

        it.skip 'rejects on 401', ->
            authResponse.respond 401, ''

            # sut = SUT()
            # err = null
            # sut.catch (e)-> err = e

            $httpBackend.flush()

            # should.exist err

        it 'resolves on 200', ->
            sut = SUT()
            user = null
            sut.then (u)-> user = u
            $httpBackend.flush()

            should.exist user
            user.should.have.property 'id'
            user.id.should.equal '123abc'

        it 'spares the request',  ->
            sut = SUT()
            $httpBackend.flush()

            sut = SUT()
            user = null
            sut.then (u)-> user = u
            $rootScope.$digest()

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

    describe '$authorizationProvider', ->
        beforeEach module 'rupert.doorman.authorization',
            ($authorizationProvider)->
                $authorizationProvider.setBaseURL('api/auth')

        $httpBackend = null
        beforeEach inject ($injector)->
            $httpBackend = $injector.get '$httpBackend'

        afterEach ->
            $httpBackend.verifyNoOutstandingRequest()
            $httpBackend.verifyNoOutstandingExpectation()

        it 'provides hook to change baseUrl', inject ($authorization)->
            $httpBackend.whenGET('/api/auth').respond 200, {id: '123abc'}
            $httpBackend.expectGET '/api/auth'
            $httpBackend.flush()
