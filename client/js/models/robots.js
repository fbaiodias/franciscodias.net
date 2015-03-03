var AmpCollection = require('ampersand-rest-collection')
var robot = require('./robot')

module.exports = AmpCollection.extend({
  model: robot,
  url: '/api/robots'
})
