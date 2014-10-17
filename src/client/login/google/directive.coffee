angular.module('rupert-doorman.login.google.directive', [
    'login.google.template'
])
.directive 'googleButton', ->
    restrict: 'E'
    templateUrl: 'login/google'
