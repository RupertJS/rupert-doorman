Path = require('path')

DoormanConfig = (config)->
    config.routes or= []
    config.routes.unshift Path.join __dirname, 'route.coffee'

module.exports = DoormanConfig
