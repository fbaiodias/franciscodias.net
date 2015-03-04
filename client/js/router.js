var Router = require('ampersand-router')
var HomePage = require('./pages/home')

var WebAppRouter = Router.extend({
  routes: {
    '': 'home',
    '(*path)': 'catchAll'
  },

  // ------- ROUTE HANDLERS ---------
  home: function () {
    this.trigger('page', new HomePage())
  },

  catchAll: function () {
    this.redirectTo('/')
  }
})

module.exports = WebAppRouter
