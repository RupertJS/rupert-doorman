global.root = __dirname;

debugger

var config = require('./server.json');
config.name = require('./package.json').name;

// require('./src/server/doorman')(config);
module.exports = require('rupert')(config); // Export for use by tools

if (require.main === module) {
    module.exports.start(function(){});
}
