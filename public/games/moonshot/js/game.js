/**************************************************
** GAME VARIABLES
**************************************************/
var canvas,			// Canvas DOM element
	ctx,			// Canvas rendering context
	keys,			// Keyboard input
	localPlayer,	// Local player
	remotePlayers,	// Remote players
	objects,		// Remote objects
	socket,			// Socket connection
	moon,
	previouslyDead = false,
	finalScores,
	youCanTake = true;

var playerXposition = 666,
	newPlayerTicks = 200,
	newPlayerTime = 200;
	shotTicks = 200,
	shotTime = 200,
	count = 2,
	counter = setInterval(timer, 100); // chama a função timer de 0,10 a 0,10 segundos

var lifeBooster = 1000,
	life = lifeBooster,
	oxygenBooster = 1000,
	oxygenTank = oxygenBooster,
	hungerBooster = 1000,
	hunger = hungerBooster;

var lowLevelLimit = 300,
	lowLevelAlertSent = false;
/**************************************************
** GAME INITIALISATION
**************************************************/
function init() {
	// Declare the canvas and rendering context
	canvas = document.getElementById("gameCanvas");
	ctx = canvas.getContext("2d");

	// Maximise the canvas
	canvas.width = window.innerWidth;
	canvas.height = window.innerHeight;

	// Initialise keyboard controls
	keys = new Keys();

	// Calculate a random start position for the local player
	// The minus 5 (half a player size) stops the player being
	// placed right on the egde of the screen
	var startX = Math.round(Math.random()*(canvas.width-5)),
		startY = Math.round((Math.random()*(canvas.height-400))+300);

	// Initialise the local player
	localPlayer = new Player(0, startY);

	// Initialise socket connection
	socket = io.connect("http://franciscodias.net", {port: 8000, transports: ["websocket"]});

	// Initialise remote players array
	remotePlayers = [];
	objects = [];

	moon = new Image();
	rocket = new Image();
	moon.src = "images/moon.png";
	rocket.src = "images/rocket.png";

	playerXposition = canvas.width/3;

	// Start listening for events
	setEventHandlers();
};


/**************************************************
** GAME EVENT HANDLERS
**************************************************/
var setEventHandlers = function() {
	// Keyboard
	window.addEventListener("keydown", onKeydown, false);
	window.addEventListener("keyup", onKeyup, false);

	// Window resize
	window.addEventListener("resize", onResize, false);

	// Socket connection successful
	socket.on("connect", onSocketConnected);

	// Socket disconnection
	socket.on("disconnect", onSocketDisconnect);

	// New player message received
	socket.on("new player", onNewPlayer);

	// New gun message received
	socket.on("new object", onNewObject);

	// Player move message received
	socket.on("move player", onMovePlayer);

	// Player dead message received
	socket.on("dead player", onDeadPlayer);

	// Player dead message received
	socket.on("player shot", function(data){
		//console.log("I'm", localPlayer.id, "and", data.shotId, "was shot");
		if(data.shotId == localPlayer.id) {
			//console.log("You've been shoot!!!")
			life -= 100;
			shotTicks = 0;
		}
	});

	// Player dead message received
	socket.on("your id", function(data){
		localPlayer.id = data.id;
	});

	// Player move message received
	socket.on("highscores", function(data){
		finalScores = data.scores.filter(function(element){
			return element.name != null && element.name != "null" && element.name != "";
		});
	});

	// Player removed message received
	socket.on("remove player", onRemovePlayer);

	// Player catch object received
	socket.on("catch object", onCatchObject);

	// Player drop object received
	socket.on("drop object", onDropObject);

	// Player low level received
	socket.on("low level", onLowLevel);
};

// Keyboard key down
function onKeydown(e) {
	if (localPlayer) {
		keys.onKeyDown(e);
	};
};

// Keyboard key up
function onKeyup(e) {
	if (localPlayer) {
		keys.onKeyUp(e);
	};
};

// Browser window resize
function onResize(e) {
	// Maximise the canvas
	canvas.width = window.innerWidth;
	canvas.height = window.innerHeight;
};

// Socket connected
function onSocketConnected() {
	console.log("Connected to socket server");

	// Send local player data to the game server
	socket.emit("new player", {x: localPlayer.getX(), y: localPlayer.getY()});
};

// Socket disconnected
function onSocketDisconnect() {
	console.log("Disconnected from socket server");
};

// New player
function onNewPlayer(data) {
	console.log("New player connected: "+data.id);

	newPlayerTicks = 0;
	
	// Initialise the new player
	var newPlayer = new Player(data.x, data.y);
	newPlayer.id = data.id;
	newPlayer.dead = data.dead;

	// Add new player to the remote players array
	remotePlayers.push(newPlayer);
};

// New object
function onNewObject(data) {
	//console.log("New object!", data.id);
	var newObject;

	switch(data.id.charAt(0)) {
		case "G":
			newObject = new Gun(data.x, data.y);
			break;
		case "M":
			newObject = new Matches(data.x, data.y);
			break;
		case "A":
			newObject = new Apple(data.x, data.y);
			break;
		case "F":
			newObject = new FirstAid(data.x, data.y);
			break;
		case "O":
			newObject = new Oxygen(data.x, data.y);
			break;
		case "C":
			newObject = new Compass(data.x, data.y);
			break;
		case "I":
			newObject = new Instructions(data.x, data.y);
			break;
		case "P":
			switch(data.id.charAt(1)){
			case "F":
				newObject = new PillFood(data.x, data.y);
				break;
			case "O":
				newObject = new PillOxygen(data.x, data.y);
				break;
			case "L":
				newObject = new PillLife(data.x, data.y);
				break;
			}
		break;
	}

	newObject.setOn(data.onPlayer);
	newObject.id = data.id;

	// Add new object to the objects array
	objects.push(newObject);

};

// Move player
function onMovePlayer(data) {
	var movePlayer = playerById(data.id);

	// Player not found
	if (!movePlayer) {
		console.log("Player not found: "+data.id);
		return;
	};

	// Update player position
	movePlayer.setX(data.x);
	movePlayer.setY(data.y);
};

// Dead player
function onDeadPlayer(data) {
	var deadPlayer = playerById(data.id);

	//console.log("I'm", localPlayer.id, "and", data.id, "is dead");
		
	// Player not found
	if (!deadPlayer) {
		console.log("Player not found: "+data.id);
		return;
	};
	//console.log("DEEEEAD");
	deadPlayer.dead = true;
	//console.log(JSON.stringify(remotePlayers));
};

// Catch Object
function onCatchObject(data) {
	// Find player in array

	var catchPlayer = playerById(data.id);
	var catchObject = objectById(data.objectId);
	// Player not found
	if (!catchPlayer) {
		console.log("Player not found: "+this.id);
		return;
	};

	if(!catchObject) {
		console.log("Object not found: "+data.objectId);
		return;
	};
	catchPlayer.objectId = catchObject.id;
	catchObject.setOn(true);

	//console.log(JSON.stringify(catchObject));
};

// Drop Object
function onDropObject(data) {
	//console.log("DROP", data.objectId)

	var dropObject = objectById(data.objectId);

	if(dropObject) {
		dropObject.setOn(false);
		dropObject.setX(data.x);
		dropObject.setY(data.y);

		if(data.id == localPlayer.id) {
			if(localPlayer.objectId == dropObject.id){
				localPlayer.objectId = "";
			}
		} else {
			var dropPlayer = playerByObjectId(dropObject.id);
			if(dropPlayer.objectId == dropObject.id){
				dropPlayer.objectId = "";		
			}
		}

	};
};

// Remove player
function onRemovePlayer(data) {
	var removePlayer = playerById(data.id);

	// Player not found
	if (!removePlayer) {
		console.log("Player not found: "+data.id);
		return;
	};

	// Remove player from array
	remotePlayers.splice(remotePlayers.indexOf(removePlayer), 1);
};

// Low level
function onLowLevel(data) {
	var lowPlayer = playerById(data.id);

	// Player not found
	if (!lowPlayer) {
		console.log("Player not found: "+data.id);
		return;
	};

	lowPlayer.lowLevelTicks = 0;
	lowPlayer.lowLevelKind = data.kind;

	console.log("received low level of", data.kind, "from", lowPlayer.id);
};

/**************************************************
** GAME ANIMATION LOOP
**************************************************/
function animate() {
	if (!(life <=0)) {
		update();
	} else if(!previouslyDead) {
		socket.emit("dead player", {x: localPlayer.getX(), y: localPlayer.getY()});

		var dropObject = objectById(localPlayer.objectId);
		if(dropObject) {
			dropObject.setOn(false);
			dropObject.setX(localPlayer.getX());
			dropObject.setY(localPlayer.getY()-50);
		}
		socket.emit("drop object", {id: localPlayer.id, objectId: localPlayer.objectId, x: localPlayer.getX()+150, y: localPlayer.getY()  });	
		localPlayer.objectId = "";

		var name = prompt("You got "+localPlayer.getX()+" away from the ship. \n What's your name?");
		socket.emit("player score", {score: localPlayer.getX(), playerName: name});
		previouslyDead = true;
	}
	draw();

	// Request a new animation frame using Paul Irish's shim
	window.requestAnimFrame(animate);
};


/**************************************************
** GAME UPDATE
**************************************************/
function update() {
	// Update local player and check for change
	// Send local player data to the game server

	if (localPlayer.update(keys)) {
		socket.emit("move player", {x: localPlayer.getX(), y: localPlayer.getY()});
		if(hunger>0) hunger--;
		if(oxygenTank>0) oxygenTank--;
	}

	if(oxygenTank>0) oxygenTank--;

	if(oxygenTank<=0 || hunger<=0) life--;


	var i;
	for (i = 0; i < objects.length; i++) {
		if(checkCollision(localPlayer, objects[i]) && youCanTake) {
			objects[i].setOn(true);
			localPlayer.objectId = objects[i].id;
			youCanTake = false;
			count = 4;

			//console.log(JSON.stringify(player))

			// Send local player data to the game server
			socket.emit("catch object", {objectId: objects[i].id});	
		};
	};

	if (localPlayer.objectId && keys.x){
		var dropObject = objectById(localPlayer.objectId);
		if(dropObject) {
			dropObject.setOn(false);
			dropObject.setX(localPlayer.getX()+150);
			dropObject.setY(localPlayer.getY());
		}
		socket.emit("drop object", {id: localPlayer.id, objectId: localPlayer.objectId, x: localPlayer.getX()+150, y: localPlayer.getY()  });	
		localPlayer.objectId = "";
	}

	
	switch(localPlayer.objectId.charAt(0)) {
		case "O":
			oxygenTank = oxygenBooster;
			break;
		case "F":
			if(oxygenTank>0 && hunger>0) life = lifeBooster;
			break;
		case "A":
			hunger = hungerBooster;
			break;
		case "P":
			switch(localPlayer.objectId.charAt(1)) {
				case "F":
					hunger = 1300;
					hungerBooster = 1300;
					break;
				case "L":
					life = 1300;
					lifeBooster = 1300;
					break;
				case "O":
					oxygenTank = 1300;
					oxygenBooster = 1300;
					break;
			}
			break;		
		case "G":
			if (keys.shift){
				objectById(localPlayer.objectId).shoot(localPlayer);
			}

			var gun = objectById(localPlayer.objectId);
				
			for (i = 0; i < remotePlayers.length; i++) {
				if(gun.getBullet()){
					if(checkCollision(remotePlayers[i], gun.getBullet())) {
						socket.emit("player shot", {shotId: remotePlayers[i].id, shooterId: localPlayer.id});	
						console.log("SHOT");
					}
				}
			};
			break;
	}

	if ((hunger <= lowLevelLimit || oxygenTank <= lowLevelLimit || life <= lowLevelLimit)) {
		if(lowLevelAlertSent == false) {
			lowLevelAlertSent = true;
			
			if(oxygenTank <= lowLevelLimit) {
				socket.emit("low level", {kind:"oxygenTank"});
			} else if(hunger <= lowLevelLimit) {
				socket.emit("low level", {kind:"hunger"});
			} else if(life <= lowLevelLimit) {
				socket.emit("low level", {kind:"life"});
			}
		}
	}
	else {
		lowLevelAlertSent = false;
	}

};


/**************************************************
** GAME DRAW
**************************************************/
function drawBackground(player) {
	ctx.fillStyle = "rgb(0,0,50)";
  	ctx.fillRect(0, 0, canvas.width, canvas.height);
	
	var moonStart = Math.floor(player.getX() / moon.width);
	var moonRepeats = Math.floor(canvas.width / moon.width)+2;

	for(var i=moonStart; i<moonStart+moonRepeats; i++) {
		var moonX = -player.getX()+i*moon.width;
		var moonY = canvas.height - moon.height;
		ctx.drawImage(moon,moonX,moonY);		
	}

	ctx.drawImage(rocket, playerXposition-(player.getX()), canvas.height-600);

}

function drawInformation(x,y) {

  	ctx.font="20px Arial";

	ctx.fillStyle = "rgb(255,255,255)";
  	ctx.fillText(remotePlayers.length+" other player(s) in game rigth now.",x,y-10);
  	
	ctx.fillStyle = "rgb(0,0,255)";
  	ctx.fillRect(x, y, oxygenTank/5, 20);
  	ctx.fillStyle = "rgb(255,0,0)";
  	ctx.fillRect(x, y+30, life/5, 20);
  	ctx.fillStyle = "rgb(255,255,0)";
  	ctx.fillRect(x, y+60, hunger/5, 20);
  	
	ctx.fillStyle = "rgb(150,150,150)";
  	ctx.fillText("OXYGEN",x,y+18);
	ctx.fillText("LIFE",x,y+48);
	ctx.fillText("HUNGER",x,y+78);


  	ctx.fillStyle = "rgb(255,255,0)";
  	ctx.font="30px Arial";
	if(newPlayerTicks < newPlayerTime) {
		ctx.fillText("New player connected",canvas.width/2-200,50);
  		newPlayerTicks++;
  	}
	if(shotTicks < shotTime) {
		ctx.fillText("You've been shot!!!",canvas.width/2-200,50);
  		shotTicks++;
  	}

  	ctx.font="Bold 30px Courier";
  	ctx.strokeStyle = 'black';
    ctx.lineWidth = 8;
  	ctx.fillStyle = "rgb(25,243,50)";
	if(finalScores) {
		ctx.strokeText("Highscores",canvas.width/2-215,150);
		ctx.fillText("Highscores",canvas.width/2-215,150);
		for(var i=0; i<finalScores.length && i<10; i++) {
    		ctx.strokeText((i+1) + " - " + finalScores[i].name + " - " + finalScores[i].score,canvas.width/2-215,200+40*i);
			ctx.fillText((i+1) + " - " + finalScores[i].name + " - " + finalScores[i].score,canvas.width/2-215,200+40*i);	
		}
	}

}

function draw() {
	// Draw the background
	drawBackground(localPlayer)
	// Draw the local player
	if (!(life <=0)) {
		localPlayer.draw(ctx);
	}
	else{
		localPlayer.drawDead(ctx);
	}


	// Draw the remote players
	var i;
	for (i = 0; i < remotePlayers.length; i++) {
		remotePlayers[i].drawAsRemote(ctx, localPlayer);
	};
	for (i = 0; i < objects.length; i++) {
		objects[i].draw(ctx, localPlayer);
	}
	
	if(localPlayer.objectId.charAt(0)=="I"){
		objectById(localPlayer.objectId).draw(ctx, localPlayer);
	}

	drawInformation(50,50)
};


/**************************************************
** GAME HELPER FUNCTIONS
**************************************************/
// Find player by ID
function playerById(id) {
	var i;
	for (i = 0; i < remotePlayers.length; i++) {
		if (remotePlayers[i].id == id)
			return remotePlayers[i];
	};
	
	return false;
};
// Find player by objectId
function playerByObjectId(id) {
	var i;
	for (i = 0; i < remotePlayers.length; i++) {
		if (remotePlayers[i].objectId == id)
			return remotePlayers[i];
	};
	
	return false;
};

// Find object by ID
function objectById(id) {
	var i;
	for (i = 0; i < objects.length; i++) {
		if (objects[i].id == id)
			return objects[i];
	};
	
	return false;
};

function checkCollision(player, object) {
	//console.log(object.getX(), object.getY(), object.width, object.height)
	if (!object.isOnPlayer() && player.getX() < object.getX() + object.width  && player.getX() + player.width  > object.getX() &&
    player.getY() < object.getY() + object.height && player.getY() + player.height > object.getY()) {
		// The objects are touching
		return true;
	}
	return false;
}

function printScores() {
	var count = 1;
	for(var i=0; i<finalScores.length; i++){
		console.log(count++, finalScores[i].score, finalScores[i].name);
	}
}

function timer() { //timer usado para poder apanhar os objectos mais lentamente 
  count=count-1;
  if (count <= 0){
     youCanTake = true;
     count = 4;
  }
}


