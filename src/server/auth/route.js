var session = require('express-session');
var passport = require('passport');
var storage = require('./storage');
var debug = require('debug')('rupert:doorman:route');
var logger = null;

function attach(name, config, app, base) {
  var oauth2 = false;

  if (name === 'oauth2') {
    oauth2 = true;
    config.libPath = 'passport-oauth';
  }

  // Older OAuth 1 settings. TODO Consider removing?
  if (config.returnURL || config.realm) {
    oauth2 = false;
  }

  // Google's oauth needs its own lib.
  if (name === 'google') {
    config.libPath = 'passport-google-oauth';
  }

  // Standard OAuth2 configs, takes precendence.
  if (config.clientID && config.clientSecret) {
    oauth2 = true;
  }

  var lib = require(config.libPath || ('passport-' + name));

  var Strategy = (oauth2 && lib.OAuth2Strategy) ?
    lib.OAuth2Strategy :
    (lib.OAuthStrategy ?
      lib.OAuthStrategy :
      lib.Strategy);

  debug('Adding strategy: ' + Strategy.name || Strategy);
  var strategy = new Strategy(config, storage.wrapStore);
  passport.use(name, strategy);

  app.get('/' + base + '/' + name + '/connect', passport.authenticate(name));
  app.get('/' + base + '/' + name + '/callback', passport.authenticate(name), storeUser, close);
}

function DoormanRouter(app, config) {
  logger = app.logger;
  var base = config.find('doorman.base', 'DOORMAN_BASE', 'doorman');
  var sessionDeets = config.find('doorman.session');

  debug('Configuring session with ', sessionDeets);

  app.use(session(sessionDeets));
  app.use(passport.initialize());
  app.use(passport.session());

  var users = {};

  passport.serializeUser(function(user, done) {
    users[user.id] = user;
    done(null, user.id);
  });
  passport.deserializeUser(function(id, done) {
    var user = users[id];
    done(null, user);
  });

  config.map('doorman.providers', function(name, provider) {
    provider.callbackURL = '/' + base + '/' + name + '/callback';
    return provider;
  });

  var ref = config.find('doorman.providers');
  for (var provider in ref) {
    var providerConfig = ref[provider];
    try {
      attach(provider, providerConfig, app, base);
    } catch (_error) {
      var e = _error;
      logger.warn('Failed to connect authentication provider.');
      logger.info(e.stack);
    }
  }

  app.get('/' + base, function(req, res) {
    if (req.user) {
      var user = JSON.parse(JSON.stringify(req.user));
      delete user.tokens;
      return res.send(user);
    } else {
      return res.status(401).send();
    }
  });
}

function storeUser(req, res, next){
  debug('Sign on complete, storing user: ', req.user);
  // TODO how to Invert Control...
  next();
}


function authed(req, res) { // jshint ignore:line
  return res.status(204).send();
}

function close(req, res) { // jshint ignore:line
  debug('Completing login; returning OAuth window close script.');
  return res.send('<html><head><title>Rupert Doorman Utility</title></head><body><script>debugger; window.opener.RupertDoormanLoggedIn(); window.close();</script></body></html>');
}


module.exports = DoormanRouter;
