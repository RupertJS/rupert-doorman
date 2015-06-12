class Authorization
    constructor: (@$http, @$q, @$window, @$rootScope, @root)->
        @user = null

    connectUrl: (provider)->
        "/#{@root}/#{provider}/connect"

    connect: (provider)->
        # Open a new window
        @$window.open @connectUrl provider

    IsLoggedIn: ->
        chain =
            if @user?
                @$q.when({data: @user})
            else
                @$http.get("/#{@root}")
        chain.then ({data})=>
            @$rootScope.$broadcast '$authorizationSuccess', data
            @user = data
        .catch (err)=>
            @$rootScope.$broadcast '$authorizationError', err
            throw err

Authorization.$inject = [
  '$http'
  '$q'
  '$window'
  '$rootScope'
]

class AuthorizationProvider
    constructor: ->
        @root = 'doorman'
    setBaseURL: (@root)->
    $get: ($http, $q, $window, $rootScope)->
        new Authorization $http, $q, $window, $rootScope, @root

AuthorizationProvider::$get.$inject = Authorization.$inject

angular.module('rupert.doorman.authorization', [])
.provider('$authorization', AuthorizationProvider)
.factory 'IsLoggedIn', ($authorization)->
    $authorization.IsLoggedIn.bind $authorization
.run (IsLoggedIn)-> IsLoggedIn()
