/*global app*/
var PageView = require('./base')
var templates = require('../templates')
var RobotsArea = require('client/js/views/robots/area')

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
    }
  }
})
