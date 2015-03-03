var log = require('bows')('robots')
var PageView = require('client/js/pages/base')
var templates = require('client/js/templates')
var RobotsView = require('client/js/views/robots/view')

module.exports = PageView.extend({
  template: templates.views.cards,
  render: function () {
    this.renderWithTemplate()
    this.renderCollection(this.collection, RobotsView, this.queryByHook('cards-container'))
    if (!this.collection.length) {
      this.fetchCollection()
    }
  },
  fetchCollection: function () {
    log('fetching robots')
    this.collection.fetch()
    return false
  }
})
