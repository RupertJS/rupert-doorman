store = {}

module.exports =
    Store: (provider, tokens, user, done)->
        user[provider].tokens = tokens
        store[user.id] = user
        done null, user
