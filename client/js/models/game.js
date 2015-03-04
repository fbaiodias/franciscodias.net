var AmpModel = require('ampersand-model')

module.exports = AmpModel.extend({
  props: {
    id: 'string',
    name: 'string',
    description: 'string',
    url: 'string',
    image: 'string',
    video: 'string'
  },
  derived: {
    viewUrl: {
      deps: ['url'],
      fn: function () {
        return this.url
      }
    },
    imageUrl: {
      deps: ['image'],
      fn: function () {
        return '/static/images/' + this.image
      }
    }
  }
})
