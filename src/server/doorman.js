var doorman = require('./auth/config');

doorman.storage = require('./auth/storage');

var authFailed = function(req, res, next) {
  return res.sendStatus(401);
};

doorman.defaultAuthorizationFailed = function(fn) {
  authFailed = fn;
};

doorman.isLoggedIn = function(req, res, next) {
  if (!req.user) {
    return authFailed(req, res, next);
  }
  return next();
};

module.exports = doorman;
