class Authorization
    constructor: (@$http, @$q)->

Authorization.$inject = [
    '$http'
    '$q'
]

angular.module('rupert.doorman.authorization', [

]).service '$authorization', Authorization
