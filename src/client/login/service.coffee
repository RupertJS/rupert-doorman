class Authentication
    constructor: (@$cookies, @$http, @$location, @$rootScope)->
        @noCookies = no
        @check()
        @user =
            username: ''
            password: ''

    check: ->
        # Evaluate for its $cookies side effects
        @$http.get('/auth/check').catch -> # Dont't care

    isLoggedIn: ->
        (@$cookies.li? and @$cookies.li isnt 0) or (@noCookies and @li)

    login: ->
        @$http
        .post('/auth/login/local', @user)
        .then =>
            unless @isLoggedIn()
                @noCookies = yes
                @li = yes
            @$location.url '/'
        .catch (error)=>
            if error.status is 403
                @$rootScope.$broadcast '$loginFailed'

    logout: ->
        @user.username = ''
        @user.password = ''
        @noCookies = no
        @li = no
        @$http.get('/auth/logout')

Authentication.$inject = [
    '$cookies'
    '$http'
    '$location'
    '$rootScope'
]

angular.module('rupert-doorman.login.service', [
    'ngCookies'
]).service 'DoormanSvc', Authentication
