angular.module('rupert.doorman', [
    'ngAnimate',
    'rupert.doorman.login',
    'rupert.doorman.authorization',
]).config(function($authorizationProvider){
}).controller('OAuthLoginController', function OAuthLoginController($authorization){
    this.loginWith = function(provider){
        $authorization.connect(provider);
    };
}).controller('RupertProfileController', function RuperProfileController($scope, IsLoggedIn, $authorization){
    if($authorization.user)
        this.name = $authorization.user.displayName;
    else
        this.name = 'You have not logged in.';

    this.checkAgain = IsLoggedIn;
    $scope.$on('$authorizationSuccess', function(event, user){
        this.name = user.displayName;
    }.bind(this));
});
