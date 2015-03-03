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
      deps: ['id'],
      fn: function () {
        return '/robots/' + this.id
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
