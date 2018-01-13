const rc = require('rc')

const defaults = require('./defaults.json')

var ret = rc('retronewsci', defaults)
//console.log('conf', ret)

module.exports = ret