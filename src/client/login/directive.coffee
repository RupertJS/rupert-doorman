directive = angular.module('rupert-doorman.login.directive', [
    'ngAnimate'
    'ui.router'
    'rupert-doorman.login.google'
    'rupert-doorman.login.facebook'
    'rupert-doorman.login.service'
    'login.template'
])
.config ($stateProvider)->
    console.log 'rupert-doorman.login.directive::config'
    $stateProvider.state
        name: 'login'
        url: '/login'
        views:
            main:
                template: """
                    <div class="row">
                        <div class="col-md-6 col-md-offset-3">
                            <rupert-login></rupert-login>
                        </div>
                    </div>
                """

# .run ($rootScope, $state, DoormanSvc)->
#     console.log 'rupert-doorman.login.directive::run'
#     loginRedirect = ->
#         unless DoormanSvc.isLoggedIn() or $state.is('login')
#             $state.go('login')
#     $rootScope.$on '$locationChangeSuccess', loginRedirect
#     loginRedirect()

loginHandler = ($scope, $timeout, DoormanSvc)->
    $scope.isAndroid = ionic?.Platform.isAndroid()
    $scope.failed = false
    _promise = null
    $scope.failure = ""
    $scope.$on 'Server Unavailable', (err, server)->
        $scope.failed = true
        $scope.failure = "Server #{server} unavailable."
        $timeout.cancel _promise if _promise? # Cancel last timeout
        _promise = $timeout (->$scope.failed = false), 5e3 # 5 seconds
    $scope.$on '$loginFailed', ->
        $scope.failed = true
        $scope.failure = 'Invalid username or password.'
        $timeout.cancel _promise if _promise? # Cancel last timeout
        _promise = $timeout (->$scope.failed = false), 5e3 # 5 seconds

directive.directive 'rupertLogin', ->
    restrict: 'AE'
    templateUrl: 'login'
    controller: ($scope, $timeout, DoormanSvc)->
        $scope.auth = DoormanSvc
        loginHandler $scope, $timeout, DoormanSvc
