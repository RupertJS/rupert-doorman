var doorman = require('./auth/config');

doorman.storage = require('./auth/storage');

var authFailed = function(req, res) {
  return res.status(401).send();
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
