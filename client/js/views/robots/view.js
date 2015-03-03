var View = require('ampersand-view')
var templates = require('client/js/templates')

module.exports = View.extend({
  template: templates.views.card,
  bindings: {
    'model.name': { hook: 'name' },
    'model.imageUrl': { type: 'attribute', hook: 'img', name: 'src' },
    'model.viewUrl': { type: 'attribute', hook: 'action-view', name: 'href' }
  }
})
