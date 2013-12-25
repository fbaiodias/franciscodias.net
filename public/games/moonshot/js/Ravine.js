/**************************************************
** GAME Ravine CLASS
**************************************************/
var Ravine = function(startX, startY) {
	var x = startX,
		y = startY,
		onPlayer = false,
		fixed = false,
		image = new Image(),
		imageFixed = new Image(),
		imageBalon = new Image(),
		id;

	image.src = "images/ravine.png";
	imageFixed.src = "images/ravineRope.png";
	imageBalon.src = "images/balon.png";
	
	var width = 500,
		height = 480;

	console.log("NEW RAVE");

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

	var setOn = function(newY) {
		onPlayer = newY;
	};

	var draw = function(ctx, localPlayer) {
		var imageX = playerXposition-(localPlayer.getX()-x),
			imageY = y;

		if(this.fixed) {
			ctx.drawImage(imageFixed, imageX, imageY);
		}
		else {
			ctx.drawImage(image, imageX, imageY);	
		}

	};	

	var drawOn = function(ctx, imageX, imageY) {
		/*
		var imageX = playerXposition-(localPlayer.getX()-x)-image.width/2,
			imageY = y-image.height/2;

		ctx.drawImage(imageBalon, imageX-45, imageY-70);
		ctx.drawImage(image, imageX-40, imageY-60);
		*/
	};	

	// Define which variables and methods can be accessed
	return {
		getX: getX,
		getY: getY,
		isOnPlayer: isOnPlayer,
		setX: setX,
		setY: setY,
		setOn: setOn,
		draw: draw,
		drawOn: drawOn,
		height: height,
		width: width,
		fixed: fixed,
		id: id
	}
};