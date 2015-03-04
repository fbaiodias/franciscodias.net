/*global app*/
var PageView = require('./base')
var templates = require('../templates')
var RobotsArea = require('client/js/views/robots/area')
var GamesArea = require('client/js/views/games/area')

module.exports = PageView.extend({
  pageTitle: 'Francisco Baio Dias',
  template: templates.pages.home,
  subviews: {
    robots: {
      container: '[data-hook=robots-container]',
      prepareView: function (el) {
        return new RobotsArea({
            el: el,
            collection: app.robots
          })
      }
    },
    games: {
      container: '[data-hook=games-container]',
      prepareView: function (el) {
        return new GamesArea({
            el: el,
            collection: app.games
          })
      }
    }
  }
})
