var config = {
  isDev: true,
  isSecure: false
}

config.session = {
  host: 'localhost',
  port: 6379,
  db: 1,
  secret: 'bang!',
  secure: false
}

config.hapi = {
  host: '0.0.0.0',
  port: 3000
}

// Client side
config.client = {
  isDev: config.isDev,
  debugMode: true,
  title: 'My Webapp'
}

module.exports = config
