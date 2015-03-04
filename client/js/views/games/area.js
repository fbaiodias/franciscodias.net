var log = require('bows')('games')
var PageView = require('client/js/pages/base')
var templates = require('client/js/templates')
var GamesView = require('client/js/views/games/view')

module.exports = PageView.extend({
  template: templates.views.cards,
  render: function () {
    this.renderWithTemplate()
    this.renderCollection(this.collection, GamesView, this.queryByHook('cards-container'))
    if (!this.collection.length) {
      this.fetchCollection()
    }
  },
  fetchCollection: function () {
    log('fetching games')
    this.collection.fetch()
    return false
  }
})
