/**************************************************
** GAME GUN CLASS
**************************************************/
var Gun = function(startX, startY) {
	var x = startX,
		y = startY,
		onPlayer = false,
		image,
		imageBalon,
		bullet,
		//playerXposition = 666,
		id;

	image = new Image();
	imageBalon = new Image();
	image.src = "images/gun.png";
	imageBalon.src = "images/balon.png";

	var width = 60,
		height = 60;
	

	// Getters and setters
	var getX = function() {
		return x;
	};

	var getY = function() {
		return y;
	};

	var getBullet = function() {
		return bullet;
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

	var shoot = function(localPlayer) {
		bullet = new Bullet(localPlayer.getX(), localPlayer.getY());
	};

	var draw = function(ctx, localPlayer) {
		if (onPlayer == false){
			var imageX = playerXposition-(localPlayer.getX()-x)-image.width/2,
				imageY = y-image.height/2;

			ctx.drawImage(image, imageX, imageY);
		}
		else if(localPlayer.objectId == this.id){
			ctx.drawImage(imageBalon, playerXposition-90, localPlayer.getY()-120)
			ctx.drawImage(image, playerXposition-86, localPlayer.getY()-110)
		}

		if(bullet) {
			bullet.update();
			bullet.draw(ctx, localPlayer);
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
		shoot: shoot,
		height: height,
		width: width,
		getBullet: getBullet,
		id: id
	}
};