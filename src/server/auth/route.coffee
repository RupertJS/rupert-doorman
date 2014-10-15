check = (req, res, next)->
    if req.cookies.li?.maxAge <= 0
        username = req.cookies.username
        req.logout()

        # ['li', 'username', 'roles'].forEach (_)->
        res.clearCookie 'li', {path: '/'}

    res.status(204).send()

route = (app)->
    app.get '/auth/check', check

module.exports = route
