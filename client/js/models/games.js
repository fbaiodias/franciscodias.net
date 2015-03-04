var AmpCollection = require('ampersand-rest-collection')
var game = require('./game')

module.exports = AmpCollection.extend({
  model: game,
  url: '/api/games'
})
