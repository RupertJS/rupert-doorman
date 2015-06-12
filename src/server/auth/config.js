var debug = require('debug')('rupert:doorman:config');
var Path = require('path');

var secret = (function() {
  var chars;
  chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  return function() {
    return ((function() {
      var i, results;
      results = [];
      for (i = 0; i < 24; i++) {
        results.push(chars[Math.floor(Math.random() * chars.length)]);
      }
      return results;
    }()).join(''));
  };
}());

function DoormanConfig(config) {
  var route = Path.join(__dirname, 'route.js');
  var relative = Path.resolve(process.cwd(), route);
  config.prepend('routing', relative);
  debug('Added doorman routing, ' + relative);
  var s = config.find('doorman.session.secret', 'SESSION_SECRET', secret());
  debug('Secret for this instance is ' + s);
  config.find('doorman.session.resave', false);
  config.find('doorman.session.saveUninitialized', false);
  var secure = config.tls ? true : false;
  config.find('doorman.session.cookie.secure', secure);
}

module.exports = DoormanConfig;
