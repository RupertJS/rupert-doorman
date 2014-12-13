AbstractStrategy = require('passport-strategy')

testProfile =
    provider: 'test'
    id: '123abc'
    displayName: 'Test User'
    name:
        familyName: 'User'
        givenName: 'Test'
        middleName: ''
    emails: [
        {
          value: 'test.user@example.com'
          type: 'personal'
        }
    ]
    photos: []

Strategy = (config, store)->
    @_verify = store
    AbstractStrategy.call @
Strategy:: = Object.create(AbstractStrategy::)

Strategy::authenticate = (req, options)->
    if req.query.code
        verified = (err, user, info)=>
            return @error(err) if err
            return @fail(info) unless user
            return @success(user, info)
        try
            @_verify(req.query.code, testProfile, verified)
        catch e
            @error e
    else
        @redirect 'http://example.com/testOAuthLogin'

module.exports = { Strategy }
