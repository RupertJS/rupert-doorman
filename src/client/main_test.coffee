describe 'Rupert Doorman', ->
    beforeEach module 'rupert.doorman'
    it 'Loads', inject (DoormanSvc)->
        should.exist(DoormanSvc)
