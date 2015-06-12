var store = {};

var storage = module.exports = {
  wrapStore: function() {
    var e, profile, provider, tokens, val;
    var args = Array.prototype.slice.call(arguments, 0, -1);
    var done = Array.prototype.slice.call(arguments, -1)[0];
    switch (args.length) {
      case 1:
        return done(new Error('Not handling openid without user.'));
      case 2:
        profile = args[1];
        if (profile.provider) {
          provider = profile.provider || 'openid_unknown';
          tokens = {
            identifier: args[0]
          };
        } else {
          return done(new Error('Not handling apparent local.'));
        }
        break;
      case 3:
        profile = args[2];
        provider = profile.provider || 'oauth_unknown';
        tokens = {
          access: args[0],
          secret: args[1]
        };
    }
    profile.tokens = profile.tokens || {};
    profile.tokens[provider] = tokens;
    try {
      val = storage.Store.call(this, provider, profile);
      if (val.then) {
        return val.then(function(user) {
          return done(null, user);
        });
      } else {
        return done(null, profile);
      }
    } catch (_error) {
      e = _error;
      return done(e);
    }
  },
  Store: function(provider, user) {
    store[user.id] = user;
    return user;
  }
};
