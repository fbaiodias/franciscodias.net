/**************************************************
** GAME SpaceShipEnding CLASS
**************************************************/
var SpaceShipEnding = function(startX, startY) {
	var x = startX,
		y = startY,
		onPlayer = false,
		rocketEnd,
		rocketGo,
		ticks = 0,
		time = 2000,
		speed = 20,
		coco = false,
		go = false,
		up = 0,
		id;

	rocketEnd = new Image();
	rocketGo = new Image();
	rocketEnd.src = "images/rocketEnd.png";
	rocketGo.src = "images/rocketGo.png";

	var width = 500,
		height = 500;
	

	// Getters and setters
	var getX = function() {
		return x;
	};

	var getY = function() {
		return y;
	};

	var isOnPlayer = function() {
		return onPlayer;
	};

	var setX = function(newX) {
		x = newX;
	};

	var setY = function(newY) {
		y = newY;
	};

	var setOn = function(newState) {
		onPlayer = newState;
	};

	var update = function() {
			if(ticks < time) {
				up += speed; 
				ticks++;
		}
	}	

	var draw = function(ctx, localPlayer) {
		var imageX = playerXposition-(localPlayer.getX()-x)-rocketEnd.width/2,
			imageY = canvas.height-600-up;

		if (this.coco == false){
			ctx.drawImage(rocketEnd, imageX, imageY);
		}
		else{
			ctx.drawImage(rocketGo, imageX, imageY);
			ctx.font="Bold 30px Courier";
  			ctx.strokeStyle = 'black';
    		ctx.lineWidth = 8;
  			ctx.fillStyle = "rgb(25,243,50)";
  			ctx.strokeText("Press X to Go!",canvas.width/2-215,150);
  			ctx.fillText("Press X to Go!",canvas.width/2-215,150);
		}	
	};	

	var drawOn = function(ctx, imageX, imageY) {
	};	

	// Define which variables and methods can be accessed
	return {
		getX: getX,
		getY: getY,
		isOnPlayer: isOnPlayer,
		setX: setX,
		setY: setY,
		update: update,
		setOn: setOn,
		draw: draw,
		drawOn: drawOn,
		height: height,
		width: width,
		coco: coco,
		go: go,
		id: id
	}
};