var Hapi = require('hapi');
var Tabletop = require('tabletop');

// globals
var sheetData = [],
    robots = [],
    games = [],
    webs = []

var uri = ""

var lastFetch;
var KEY = '0AhSAZYKyt0p7dHV5WUszV3kzczA5Q2kwUm90SnNUZHc'

var options = {
    views: {
        path: 'templates',
        engines: {
            html: 'handlebars'
        }
    }
}; 

// Create a server with a host, port, and options
var server = Hapi.createServer('0.0.0.0', 80, options);

Tabletop.init( { key: '0AhSAZYKyt0p7dHV5WUszV3kzczA5Q2kwUm90SnNUZHc',
                 callback: function(data, tabletop) { 
                   	//console.log(data); 
                   	sheetData = data;
                    robots = sheetData.Robots.elements;
                    games = sheetData.Games.elements;
                    webs = sheetData.Webs.elements;
					},
				simpleSheet: false} )

var routes = [
    { method: 'GET', path: '/', config: { handler: homeHandler } },

    // Stupid shit to be fixed
    { method: 'GET', path: '/game/css/{path*}', handler: {
        directory: { path: './public/css', listing: true, index: true }
    } },
    { method: 'GET', path: '/game/js/{path*}', handler: {
        directory: { path: './public/js', listing: true, index: true }
    } },
    { method: 'GET', path: '/robot/css/{path*}', handler: {
        directory: { path: './public/css', listing: true, index: true }
    } },
    { method: 'GET', path: '/robot/js/{path*}', handler: {
        directory: { path: './public/js', listing: true, index: true }
    } },
    { method: 'GET', path: '/web/css/{path*}', handler: {
        directory: { path: './public/css', listing: true, index: true }
    } },
    { method: 'GET', path: '/web/js/{path*}', handler: {
        directory: { path: './public/js', listing: true, index: true }
    } },
    // End of Stupid shit

    { method: 'GET', path: '/game/{id}', config: { handler: getGame } },
    { method: 'GET', path: '/robot/{id}', config: { handler: getRobot } },
    { method: 'GET', path: '/web/{id}', config: { handler: getWeb } },


    { method: 'GET', path: '/{path*}', handler: {
        directory: { path: './public', listing: true, index: true }
    } }
];

server.addRoutes(routes);

function getRobots(request, reply) {

    if (request.query.name) {
        return reply(findRobots(request.query.name));
    }

    reply(robots);
}

function findRobots(name) {

    return robots.filter(function(robot) {
        return robot.name.toLowerCase() === name.toLowerCase();
    });
}

function getRobot(request, reply) {

    var robot = robots.filter(function(p) {
        return p.id === request.params.id;
    }).pop();

    //reply(robot);

    reply.view('robot.html', { 
        uri: uri,
        name: 'Francisco Baio Dias', 
        byline: 'Student @IST', 
        robot: robot
    });
}

function getGames(request, reply) {

    if (request.query.name) {
        return reply(findGames(request.query.name));
    }

    reply(games);
}

function findGames(name) {

    return games.filter(function(game) {
        return game.name.toLowerCase() === name.toLowerCase();
    });
}

function getGame(request, reply) {

    var game = games.filter(function(p) {
        return p.id === request.params.id;
    }).pop();

    //reply(game);

    reply.view('game.html', { 
        uri: uri,
        name: 'Francisco Baio Dias', 
        byline: 'Student @IST', 
        game: game
    });
}

function getWebs(request, reply) {

    if (request.query.name) {
        return reply(findWebs(request.query.name));
    }

    reply(webs);
}

function findWebs(name) {

    return webs.filter(function(web) {
        return web.name.toLowerCase() === name.toLowerCase();
    });
}

function getWeb(request, reply) {

    var web = webs.filter(function(p) {
        return p.id === request.params.id;
    }).pop();

    //reply(web);

    reply.view('web.html', { 
        uri: uri,
        name: 'Francisco Baio Dias', 
        byline: 'Student @IST', 
        web: web
    });

}

function toGrid(data){
    var rows=[],
        step=3,
        i=0,
        L=data.length;
    
    for(; i<L ; i+=step){
        rows.push({cells:data.slice(i,i+step)});
    };

    return rows;
}


// Define the route
 function homeHandler (request) {
    // Render the view with the custom greeting
    request.reply.view('index.html', { 
        name: 'Francisco Baio Dias', 
        byline: 'Student @IST', 
        robots: toGrid(robots), 
        webs: toGrid(webs), 
        games: toGrid(games) 
    });
};

// Start the server

server.start(function () {
    uri = server.info.uri;
    console.log('Server started at: ' + server.info.uri);
});