angular.module('rupert.doorman.login.google.directive', [
    'login.google.template'
])
.directive 'googleButton', ->
    restrict: 'EA'
    templateUrl: 'login/google'
