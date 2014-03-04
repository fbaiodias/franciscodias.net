/**************************************************
** GAME Instructions CLASS
**************************************************/
var Instructions = function(startX, startY) {
	var x = startX,
		y = startY,
		onPlayer = false,
		image,
		imageBalon,
		id;

	image = new Image();
	imageBalon = new Image();
	instructionsPanel = new Image();
	image.src = "images/instructions.png";
	imageBalon.src = "images/balon.png";
	instructionsPanel.src = "images/instructionsPanel.png"

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

	var draw = function(ctx, localPlayer) {
		if (onPlayer == false){
			var imageX = playerXposition-(localPlayer.getX()-x)-image.width/2,
				imageY = y-image.height/2;

			ctx.drawImage(image, imageX, imageY);
		}
		else if(localPlayer.objectId == this.id){
			ctx.drawImage(imageBalon, playerXposition-90, localPlayer.getY()-120);
			ctx.drawImage(image, playerXposition-81, localPlayer.getY()-115);
			ctx.strokeStyle = 'black';
    		ctx.lineWidth = 8;
			ctx.fillStyle = "rgb(0,0,0)";
			ctx.fillRect(canvas.width/2 -250-60, 100-60 ,620, 620 )
			ctx.fillStyle = "rgb(150,150,150)";
			ctx.fillRect(canvas.width/2 -250-50, 100-50 ,600, 600 )
			ctx.fillStyle = "rgb(0,0,0)";
			ctx.fillRect(canvas.width/2 -250-25, 100-25 ,550, 550 )
			ctx.fillStyle = "rgb(25,143,243)";
			ctx.fillRect(canvas.width/2 -250-20, 100-20 ,540, 540 )
			ctx.font="Bold 70px Courier";
			ctx.fillStyle = "rgb(25,243,50)";
			ctx.strokeText("Instructions:",canvas.width/2 -272,125);
			ctx.fillText("Instructions:",canvas.width/2 -272,125);
			ctx.font="Bold 30px Courier";
			ctx.strokeText("MOVE: ",canvas.width/2 -260,200); 
			ctx.fillText("MOVE: ",canvas.width/2 -260,200); 
			ctx.strokeText("Up, Down, Left, Right keys",canvas.width/2 -260,245);
			ctx.fillText("Up, Down, Left, Right keys",canvas.width/2 -260,245);
			ctx.strokeText("or W, S, A, D",canvas.width/2 -180,290)
			ctx.fillText("or W, S, A, D",canvas.width/2 -180,290)
			ctx.strokeText("SHOOT: SHIFT key",canvas.width/2 -260,380);
			ctx.fillText("SHOOT: SHIFT key",canvas.width/2 -260,380);
			ctx.strokeText("DROP OBJECT: X key",canvas.width/2 -260,450);
			ctx.fillText("DROP OBJECT: X key",canvas.width/2 -260,450);
			ctx.strokeText("YOUR DOGE OBJECTIVE:",canvas.width/2 -260,520);
			ctx.fillText("YOUR DOGE OBJECTIVE:",canvas.width/2 -260,520);
			ctx.strokeText("Find the last Dogeship!",canvas.width/2 -255,565);
			ctx.fillText("Find the last Dogeship!",canvas.width/2 -255,565);
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