var Hapi = require('hapi')
var config = require('config')
var internals = {}

var server = new Hapi.Server()
server.connection(config.hapi)

// set clientconfig cookie
internals.configStateConfig = {
  encoding: 'none',
  ttl: 1000 * 60 * 15,
  isSecure: config.isSecure
}

server.state('config', internals.configStateConfig)
internals.clientConfig = JSON.stringify(config.client)
server.ext('onPreResponse', function (request, reply) {
  if (!request.state.config && !request.response.isBoom) {
    var response = request.response
    return reply(response.state('config', encodeURIComponent(internals.clientConfig)))
  }

  return reply.continue()
})

var publicAssets = {
  method: 'GET',
  path: '/static/{path*}',
  config: {
    handler: {
      directory: {
        path: './public/',
        listing: true,
        index: true
      }
    }
  }
}

server.route(publicAssets)

// require moonboots_hapi plugin
server.register({ register: require('moonboots_hapi'), options: require('./moonbootsConfig') }, function (err) {
  if (err) {
    throw err
  }
  // If everything loaded correctly, start the server:
  server.start(function (err) {
    if (err) {
      throw err
    }
    console.log('Your app is running at: http://localhost:' + config.hapi.port + " Yep. That's pretty awesome.")
  })
})
