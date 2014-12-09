session = require('express-session')

DoormanRouter = (app, config)->
    app.use(session(config.doorman.session))

module.exports = DoormanRouter
