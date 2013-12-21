/**************************************************
** GAME Compass CLASS
**************************************************/
var Compass = function(startX, startY) {
	var x = startX,
		y = startY,
		onPlayer = false,
		image,
		imageBalon,
		frame0,
		frame1,
		frame = 0,
		framesAmount = 0,
		id;

	image = new Image();
	imageBalon = new Image();
	//frame0 = new Image();
   	//frame1 = new Image();

	image.src = "images/compass.png";
	imageBalon.src = "images/balon.png";
	//frame0.src = "images/compassRigth.png";
	//frame1.src = "images/compassLeft.png";

	var width = 60,
		height = 60;
	

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

	/*var updateFrames = function() {
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
	}*/

	var draw = function(ctx, localPlayer) {
		if (onPlayer == false){
			var imageX = playerXposition-(localPlayer.getX()-x)-image.width/2,
				imageY = y-image.height/2;

			ctx.drawImage(image, imageX, imageY);
		}
		else if(localPlayer.objectId == this.id){
			ctx.drawImage(imageBalon, playerXposition-90, localPlayer.getY()-120);
			ctx.drawImage(image, playerXposition-81, localPlayer.getY()-115);
			ctx.drawImage(image, 500, 10);
		}
	};

	var drawOn = function(ctx, imageX, imageY) {
		ctx.drawImage(imageBalon, imageX-45, imageY-70);
		ctx.drawImage(image, imageX-40, imageY-60);
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
		id: id
	}
};