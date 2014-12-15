describe 'Doorman Authorization', ->
    beforeEach module 'rupert.doorman.authorization'

    it 'exposes $authorization', inject ($authorization)->
        should.exist $authorization
