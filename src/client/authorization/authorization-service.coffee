class Authorization
    constructor: (@$http, @$q, @$window)->
        @user = null

    connectUrl: (provider)->
        "/doorman/#{provider}/connect"

    connect: (provider)->
        # Open a new window
        @$window.open @connectUrl provider

    IsLoggedIn: ->
        return @$q.when(@user) if @user?
        @$http.get('/doorman').success (data)->
            @user = data

Authorization.$inject = [
    '$http'
    '$q'
    '$window'
]

angular.module('rupert.doorman.authorization', [

])
.service('$authorization', Authorization)
.factory 'IsLoggedIn', ($authorization)->
    $authorization.IsLoggedIn.bind $authorization
