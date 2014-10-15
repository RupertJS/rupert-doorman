module.exports = (app)->
    app.all '*', (req, res, next)->
        res.set 'Access-Control-Allow-Origin', '*'
        res.set 'Access-Control-Allow-Headers', 'Content-Type'
        next()
