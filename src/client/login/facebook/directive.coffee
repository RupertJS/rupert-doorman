angular.module('rupert.doorman.login.facebook.directive', [
    'login.facebook.template'
]).directive 'facebookButton', ->
    restrict: 'EA'
    templateUrl: 'login/facebook'
