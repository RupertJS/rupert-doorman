process.env.LOG_LEVEL or= 'warn'
module.exports = (grunt)->
    require('rupert-grunt')(grunt, {
        server: __dirname + '/app.js'
    })

    grunt.registerTask 'watcher', [ 'rupert-watch' ]
    grunt.registerTask 'default', [ 'rupert-default' ]
