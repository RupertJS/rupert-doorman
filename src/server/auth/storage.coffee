store = {}

module.exports =
    wrapStore: (Store)->
        # Do magic to call Store and handle response correctly.


        ->
            args = Array::slice.call arguments, 0, -1
            done = Array::slice.call(arguments, -1)[0]

            switch args.length
                when 1
                    # openid: function(identifier, done)
                    return done new Error "Not handling openid without user."
                when 2
                    profile = args[1]
                    if profile.provider
                        # openid: function(identifier, profile, done)
                        # google: function(identifier, profile, done)
                        provider = profile.provider or 'openid_unknown'
                        tokens = identifier: args[0]
                    else
                        # local: function(username, password, done)
                        # Really don't want to handle
                        return done new Error "Not handling apparent local."
                when 3
                    # oauth: (token, tokenSecret, profile, done)
                    # twitter: (token, tokenSecret, profile, done)
                    # facebook: (accessToken, refreshToken, profile, done)
                    profile = args[2]
                    provider = profile.provider or 'oauth_unknown'
                    tokens =
                        access: args[0]
                        secret: args[1]

            profile.tokens or= {}
            profile.tokens[provider] = tokens

            try
                val = Store.apply @, [provider, profile]
                if val.then
                    val.then (user)->
                        done null, user
                else
                    done null, profile
            catch e
                done e

    Store: (provider, user)->
        store[user.id] = user
        user
