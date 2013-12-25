/**************************************************
** GAME Monster CLASS
**************************************************/
var Monster = function(startX, startY) {
	var x = startX,
		y = startY,
		onPlayer = false,
		fixed = false,
		back = false,
		frame0 = new Image(),
		frame1 = new Image(),
		frameBack0 = new Image(),
		frameBack1 = new Image(),
		imageFixed = new Image(),
		imageBalon = new Image(),
		frame = 0,
		framesAmount = 0,
		id;

	frame0.src = "images/monster1.png";
	frame1.src = "images/monster2.png";
	frameBack0.src = "images/monsterBack1.png";
	frameBack1.src = "images/monsterBack2.png";
	imageFixed.src = "images/monsterDead.png";
	imageBalon.src = "images/balon.png";
	
	var width = 500,
		height = 480;

	if (x < 0) {
		back = true;
	} else {
		back = false;
	};

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

	var updateFrames = function() {
		if (frame == 1){
			framesAmount ++
			if ( framesAmount == 7){
				frame = 0
				framesAmount = 0
			}
		}
		else{
			framesAmount ++
			if ( framesAmount == 7){
				frame = 1
				framesAmount = 0
			}
		}
	}

	var update = function() {
		updateFrames();
	};	

	var draw = function(ctx, localPlayer) {
		var imageX = playerXposition-(localPlayer.getX()-x),
			imageY = y;


		if(this.fixed) {
			ctx.drawImage(imageFixed, imageX, imageY);
		}
		else {
			if (frame == 1){
				if (back == false){
					ctx.drawImage(frame0, imageX, imageY)
				}
				else{
					ctx.drawImage(frameBack0, imageX, imageY)
				}
			}
			else{
				if (back == false){
					ctx.drawImage(frame1, imageX, imageY)
				}
				else{
					ctx.drawImage(frameBack1, imageX, imageY)
				}
			}
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
		update: update,
		draw: draw,
		drawOn: drawOn,
		height: height,
		width: width,
		fixed: fixed,
		id: id
	}
};