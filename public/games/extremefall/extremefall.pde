/* @pjs preload="assets/startScreen.png, assets/bottom.png";  */
/* @pjs preload="assets/tower.png, assets/sky.png";  */
/* @pjs preload="assets/smoke.png, assets/thought.png, assets/flash.png, assets/gil.png";  */
/* @pjs preload="assets/playerOneLeft0.png, assets/playerOneLeft1.png, assets/playerOneRight0.png, assets/playerOneRight1.png";  */
/* @pjs preload="assets/playerTwoLeft0.png, assets/playerTwoLeft1.png, assets/playerTwoRight0.png, assets/playerTwoRight1.png";  */
/* @pjs preload="assets/playerThreeLeft0.png, assets/playerThreeLeft1.png, assets/playerThreeRight0.png, assets/playerThreeRight1.png";  */
/* @pjs preload="assets/keyQ0.png, assets/keyQ1.png, assets/keyV0.png, assets/keyV1.png, assets/keyP0.png, assets/keyP1.png";  */
/* @pjs preload="assets/bubble.png, assets/gunOverlayLeft.png, assets/gunOverlayRight.png, assets/bloodOverlay.png";  */
/* @pjs preload="assets/winner.png, assets/champion.png";  */
/* @pjs preload="assets/birdLeft0.png, assets/birdLeft1.png, assets/birdRight0.png, assets/birdRight1.png";  */
/* @pjs preload="assets/beer.png, assets/gun.png, assets/plasticBag.png, assets/book.png, assets/bullet.png, assets/smallBubble.png";  */
/* @pjs preload="assets/zeca.png, assets/nuno.png, assets/fred.png";  */


int screenWidth = 1366; //document.body.clientWidtqh;
int screenHeight = 768; //document.body.clientHeight;

PImage startImg;
PImage bottomImg;
int bottomImageY = 1000;

int towerY = 0;
int towerSpeed = 20;

PImage skyImg;
int skyY = 0;
int skySpeed = 1;

PImage smokeImg;
PImage thoughtImg;
PImage flashImg;
PImage gilImg;

Player[] players = new Player[3];
Overlay[] overlays = new Overlay[8];
GameObject[] objects = new GameObject[8];
StupidGuy[] stupidGuys = new StupidGuy[3];

double horizontalSpeed = 15;
double horizontalDefaultSpeed = 15;

int currentRound = 0;
int rounds = 3;

int laserPoints = 1;
int beerPoints = 4;
int bubblePoints = 4;
int gunPoints = 2;
int bulletPoints = 6;
int bookPoints = 1;
int plasticBagsPoints = 1;
int birdPoints = 10;

int[] gilTimes;
int gilXRandom = 0;
int gilYRandom = 0;
double gilY = 1000;
double gilX = 1000;

double resolutionRatio = 1;

int levelTimeout = 1000;
int playersTimeout = 100;
long ticksTime = 0;
int frame = 0;

String thoughtText = "";
int thoughtOpacity = 0;
int thoughtOpacitySteps = 5;
String[] thoughts = { "     Mamas     ","   Coisas...   ", "      Sim.     ", "   Aliens...   ", "       42      ", "    Boobies    " };

int smokeOpacity = 0;
int smokeOpacitySteps = 5;
int horizontalSmokeSpeed = 5;

String screenName = "start";

boolean controlsHidden = true;
boolean stuffHidden = true;

void setup() 
{
	if(screenWidth > 1366) screenWidth = 1366;
	if(screenHeight > 768) screenHeight = 768;
	size(screenWidth, screenHeight);
	bottomImageY = screenHeight;
	
	background(157,221,216);
	fill(222,249,247);
	PFont fontA = loadFont("verdana");
	textFont(fontA, 120);
	text("Loading...", 350, 350);

	startImg = loadImage("assets/startScreen.png");
	
	towerImg = loadImage("assets/tower.png");
	skyImg = loadImage("assets/sky.png");
	smokeImg = loadImage("assets/smoke.png");
	thoughtImg = loadImage("assets/thought.png");
	flashImg = loadImage("assets/flash.png");
	gilImg = loadImage("assets/gil.png");
	
	bottomImg = loadImage("assets/bottom.png");
	
	players[0] = new Player("assets/playerOneLeft0.png", "assets/playerOneLeft1.png", "assets/playerOneRight0.png", "assets/playerOneRight1.png");
	players[1] = new Player("assets/playerTwoLeft0.png", "assets/playerTwoLeft1.png", "assets/playerTwoRight0.png", "assets/playerTwoRight1.png");
	players[2] = new Player("assets/playerThreeLeft0.png", "assets/playerThreeLeft1.png", "assets/playerThreeRight0.png", "assets/playerThreeRight1.png");
	
	overlays[0] = new Overlay("assets/keyQ0.png", "assets/keyQ1.png", "timer");
	overlays[1] = new Overlay("assets/keyV0.png", "assets/keyV1.png", "timer");
	overlays[2] = new Overlay("assets/keyP0.png", "assets/keyP1.png", "timer");
	overlays[3] = new Overlay("assets/bubble.png");
	overlays[4] = new Overlay("assets/gunOverlayLeft.png", "assets/gunOverlayRight.png", "direction");
	overlays[5] = new Overlay("assets/bloodOverlay.png");
	overlays[6] = new Overlay("assets/winner.png");
	overlays[7] = new Overlay("assets/champion.png");
	
	objects[0] = new GameObject("assets/birdLeft0.png", "assets/birdLeft1.png", 2, 4, "birdLeft");
	objects[1] = new GameObject("assets/birdRight0.png", "assets/birdRight1.png", 2, 4, "birdRight");
	objects[2] = new GameObject("assets/beer.png", 6, 10, "beer");
	objects[3] = new GameObject("assets/gun.png", 4, 6, "gun");
	objects[4] = new GameObject("assets/plasticBag.png", 4, 6, "plasticBag");
	objects[5] = new GameObject("assets/book.png", 4, 6, "book");
	objects[6] = new GameObject("assets/bullet.png", "bullet");
	objects[7] = new GameObject("assets/smallBubble.png", "bubble");

	stupidGuys[0] = new StupidGuy("assets/zeca.png", 1, 3, 100, "zeca");
	stupidGuys[1] = new StupidGuy("assets/nuno.png", 1, 3, 100, "nuno");
	stupidGuys[2] = new StupidGuy("assets/fred.png", 1, 3, 100, "fred");
	
	for (int i = 0; i < players.length; i++)
	{
		players[i].SetSize(80, 30);
		players[i].Speed = horizontalDefaultSpeed;
		players[i].SetPosition((double)(i + 1) * (screenWidth / 4) - players[i].Width / 2, (double)(screenHeight / 2) - 100);
	}

	for (int i = 0; i < objects.length; i++)
	{
		objects[i].Hide();
        objects[i].SetSize(38, 38);
		objects[i].SetScreenSize(screenWidth, screenHeight, resolutionRatio);
	}
	objects[6].SetSize(10, 10);
	objects[6].SetSpeed(50, 50);
	objects[6].Wait = 30;
		
	for (int i = 0; i < stupidGuys.length; i++)
	{
		stupidGuys[i].SetSize(224, 280);
		stupidGuys[i].SetScreenSize(screenWidth, screenHeight, resolutionRatio);
	}

	createRandomLevel();
}

void draw() 
{	
	if(screenName == "start")
	{
		set(0, 0,startImg);
		if(stuffHidden == true)
		{
			showStuff();
			stuffHidden = false;
		}
		textSize(40);
		text("Click to Play", 580,750);
	}
	else if(screenName == "game")
	{
		if(frame == 0) 
		{
			gameLoop();
			frame++;
		}
		else
		{
			frame = 0;
		}
	}
	else if(screenName == "end")
	{
		//set(0, bottomImageY,bottomImg);
	
	}
	else if(screenName == "pause")
	{
	
	}
}

void gameLoop()
{
	if (ticksTime < levelTimeout)
	{
		// Background Images
		updateBackground();
		
		if(controlsHidden == true)
		{
			showControls();
			controlsHidden = false;
		}
		
		// Keys
		for (int i = 0; i < players.length; i++)
		{
			if (ticksTime < playersTimeout)
			{
				if (players[i].Direction == "stop")
				{
					if(i == 0) 
						fill(83,121,35,125);
					else if(i == 1) 
						fill(198,100,146,125);
					else if(i == 2) 
						fill(54,131,197,125);
					rect(i*(screenWidth/3), 0, screenWidth/3, screenHeight);
					overlays[i].AddToPlayer(players[i]);
				}
				else
					overlays[i].Hide();
			}
			else
			{
				overlays[i].Hide();
			}
		}
		
		// Zeca bubbles
		for (int i = 0; i < stupidGuys[0].Times.length; i++)
		{
			if ((long)stupidGuys[0].Times[i] > ticksTime && (long)stupidGuys[0].Times[i] < ticksTime + 2)
			{
				objects[7].Times[0] = (int)ticksTime + objects[7].Wait;
			}
			else if (ticksTime > stupidGuys[0].Times[i] + objects[7].Wait)
			{
			
			}
		}
		for (int i = 0; i < players.length; i++)
		{
			if (players[i].BubbleOn)
			{
				// Add bubble to player
				overlays[3].AddToPlayer(players[i]);
				overlays[3].Y = players[i].Y - 25;
				players[i].BubbleOn = overlays[3].Active;
			}
		}
		
		// Update guns and bullets
		for (int i = 0; i < players.length; i++)
		{
			if (players[i].GunOn)
			{
				// Add gun to player
				overlays[4].Active = true;
				overlays[4].AddToPlayer(players[i]);
				players[i].GunOn = true;
				overlays[4].UpdateImage(); // This shouldn't be needed here but otherwhise the image isn't displayed (Bug to be found)
				// Bullet
				objects[6].SetSpeed(30, 0);
				objects[6].Update(ticksTime, players[i]);
				objects[6].Update(ticksTime);
				//objects[6].UpdateImage(); // This shouldn't be needed here but otherwhise the image isn't displayed (Bug to be found)
			}
		}
		
		// Update Stupid Guys Position
		for (int i = 0; i < stupidGuys.length; i++)
		{
			stupidGuys[i].Update(ticksTime);
		}
		
		// Update Objects
		for (int i = 0; i < 7; i++)
		{
			objects[i].Update(ticksTime);
		}
		// Update Bubble acording to Zeca
		objects[7].Update(ticksTime, stupidGuys[0], true);
		
		// Gil
		for (int i = 0; i < gilTimes.length; i++)
		{
			if (gilTimes[i] > ticksTime && gilTimes[i] < ticksTime + 10)
			{
				gilY = screenHeight/2;
				gilX = 0-500;
				gilXRandom = (int)random(5, 10);
				gilYRandom = (int)random(-10, 10);
			}
		}
		gilY -= gilYRandom * resolutionRatio;
		gilX += gilXRandom * resolutionRatio;
		
		//Update Overlays
		for (int i = 0; i < overlays.length; i++)
		{
			overlays[i].Update(ticksTime);
		}
		
		// Thought
		for (int i = 0; i < stupidGuys[1].Times.length; i++)
		{
			if (stupidGuys[1].Times[i] > ticksTime && stupidGuys[1].Times[i] < ticksTime + 2)
			{
				int o = (int)random(0, thoughts.length);
				thoughtText = thoughts[o];
				thoughtOpacity = 0;
			}
		}
		
		if ((stupidGuys[1].X < screenWidth && stupidGuys[1].X > 0) && (stupidGuys[1].Direction == "stop" || stupidGuys[1].Direction == "stop"))
		{
			if (thoughtOpacity < 100)
				thoughtOpacity += thoughtOpacitySteps;
		}

		if (ticksTime > stupidGuys[1].Timeout)
		{
			if (thoughtOpacity > 0)
				thoughtOpacity -= thoughtOpacitySteps;
			else
				thoughtText = "";
		}
		
		// Smoke
		if ((stupidGuys[2].X < screenWidth && stupidGuys[2].X > 0) && (stupidGuys[2].Direction == "stop" || stupidGuys[2].Direction == "stop"))
		{
			//soundFred.Play();
			if (smokeOpacity < 100)
				smokeOpacity += smokeOpacitySteps;
		}

		if (ticksTime > stupidGuys[2].Timeout)
		{
			if (smokeOpacity > 0)
				smokeOpacity -= smokeOpacitySteps;
		}

		if (smokeOpacity > 0)
		{
			horizontalSpeed = horizontalSmokeSpeed * resolutionRatio;
		}
		else
			horizontalSpeed = horizontalDefaultSpeed * resolutionRatio;
		
		// Player/Object Interaction
		for (int i = 0; i < players.length; i++)
		{
			if(players[i].Active)
			{
				if (players[i].MaxY > 0 && players[i].Y < screenWidth)
				{
					if (players[i].Direction != "stop") // Laser
					{
						if (players[i].MaxX > screenWidth)
						{
							//soundPain.Play();
							players[i].Score -= laserPoints;
							overlays[5].AddToPlayer(players[i]);
							overlays[5].Timeout = ticksTime + 1;
							players[i].X -= 10;
						}
						else if (players[i].X < 0)
						{
							//soundPain.Play();
							players[i].Score -= laserPoints;
							overlays[5].AddToPlayer(players[i]);
							overlays[5].Timeout = ticksTime + 1;
							players[i].X += 10;
						}
					}

					for (int o = 0; o < objects.length; o++)
					{
						if ((players[i].X < objects[o].CenterX && objects[o].CenterX < (players[i].X + players[i].Width)) && (players[i].Y <= objects[o].CenterY && objects[o].CenterY <= (players[i].Y + players[i].Height)))
						{
							if (objects[o].Type == "birdLeft" || objects[o].Type == "birdRight") // Birds
							{
								objects[o].Hide();
								//soundBird.Play();
								players[i].Score += birdPoints;
							}
							else if (objects[o].Type == "beer") // Beer
							{
								objects[o].Hide();
								players[i].Score += beerPoints;
								//soundBeer.Play();
							}
							else if (objects[o].Type == "bubble") // Bubble
							{
								if (!overlays[3].Active)
								{
									objects[o].Hide();
									//soundBubble.Play();
									players[i].BubbleOn = true;
									players[i].Score += bubblePoints;
									overlays[3].AddToPlayer(players[i]);
									overlays[3].Timeout = (int)ticksTime + overlays[3].Wait;
									overlays[3].Active = true;
								}
							}
							else if (objects[o].Type == "gun") // Gun
							{
								objects[o].Hide();
								//soundGrabGun.Play();
								players[i].GunOn = true;
								players[i].Score += gunPoints;
								overlays[4].AddToPlayer(players[i]);
								overlays[4].Timeout = (int)ticksTime + objects[6].Wait / 5;
								overlays[4].Active = true;

								objects[6].Times[0] = (int)ticksTime + objects[6].Wait / 5;
							}
							else if (objects[o].Type == "bullet") // Bullet
							{
								if (players[i].GunOn == false)
								{
									//soundPain.Play();
									overlays[5].AddToPlayer(players[i]);
									overlays[5].Timeout = ticksTime + 1;
									players[i].Score -= bulletPoints;

								}
							}
							else if (objects[o].Type == "plasticBag") // Plastic Bag
							{
								//soundBag.Play();
								players[i].Score += plasticBagsPoints;

								players[i].Y -= 10;
							}
							else if (objects[o].Type == "book") // Book
							{
								//soundBook.Play();
								players[i].Score += bookPoints;

								players[i].Y += 10;
							}
						}
					}
				}
			}
		}
		
		// Player/Player Interaction
		for (int a = 0; a < players.length; a++)
		{
			for (int b = 0; b < players.length; b++)
			{
				if (players[a].BubbleOn && overlays[3].Active)
				{
					if ((players[a].Y >= players[b].Y && players[a].Y <= players[b].MaxY) || (players[b].Y >= players[a].Y && players[b].Y <= players[a].MaxY))
					{
						if (players[a].Direction == "left")
						{
							if (players[b].MaxX > players[a].X && players[b].X < players[a].X)
							{
								players[b].X = players[a].X - players[b].Width;
							}
						}
						else if (players[a].Direction == "right")
						{
							if (players[a].MaxX > players[b].X && players[a].MaxX < players[b].MaxX)
							{
								players[b].X = players[a].X + players[a].Width;
							}
						}
					}
				}
			}
		}
		
		//  Update TextBlocks
		printMessage("<b>Player One:</b> " + str(players[0].Score) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Player Two:</b>  " +str(players[1].Score) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Player Three:</b>  " +str(players[2].Score));
		
		// Let bottom image get up in the end
		if (ticksTime > levelTimeout - 36)
		{
			if (bottomImageY > 0)
				bottomImageY -=  24 * resolutionRatio;
				
			set(0, bottomImageY,bottomImg);
		}
		
		// Flash the flash
		if (ticksTime > levelTimeout - 5 && ticksTime < levelTimeout - 1)
		{
			set(0, 0,flashImg);
		}
		
		// Update Players
		for (int i = 0; i < players.length; i++)
		{
			if(players[i].Active)
			{
				players[i].UpdatePosition(horizontalSpeed * resolutionRatio);
				players[i].UpdateImage();
			}
		}
		if (ticksTime > playersTimeout)
		{
			// Hide players
			for (int i = 0; i < players.length; i++)
			{
				if (players[i].Direction == "stop")
				{
					players[i].Hide();
				}
			}
		}
		
		// Update Objects
		for (int i = 0; i < objects.length; i++)
		{
			if(objects[i].Active)
				objects[i].UpdateImage();
		}
		
		// Update Overlays
		for (int i = 0; i < overlays.length; i++)
		{
			if(overlays[i].Active)
				overlays[i].UpdateImage();
		}
		
		// Update Stupid Guys
		for (int i = 0; i < stupidGuys.length; i++)
		{
			if(stupidGuys[i].Active)
				stupidGuys[i].UpdateImage();
		}
		
		if (thoughtOpacity > 0)
		{
			set(0, 0,thoughtImg);
			
			fill(125);
			text(thoughtText, 300, 350);
		}

		if (smokeOpacity > 0)
		{
			set(0, 0,smokeImg);
		}
	}
	else
	{
		updateScores();
		screenName = "end";
	}
	
	
	ticksTime++;
}

void startGame()
{
	screenName = "game";
}

void restartGame()
{
	createRandomLevel();

	thoughtOpacity = 0;
	smokeOpacity = 0;

	// Restart Players Variables
	for (int i = 0; i < players.length; i++)
	{
		players[i].Active = true;
		players[i].Score = 0;
		players[i].BubbleOn = false;
		players[i].GunOn = false;
		players[i].Direction = "stop";
		players[i].SetPosition((double)(i + 1) * (screenWidth / 4) - players[i].Width / 2, (double)(screenHeight / 2) - 100);
	}

	// Restart Objects Variables
	for (int i = 0; i < objects.length; i++)
	{
		objects[i].Hide();
	}

	// Restart Overlays Variables
	for (int i = 0; i < overlays.length; i++)
	{
		overlays[i].Hide();
	}

	// Restart Stupid Guys Variables
	for (int i = 0; i < stupidGuys.length; i++)
	{
		stupidGuys[i].Hide();
	}

	bottomImageY = screenHeight;

	ticksTime = 0;
	
	screenName = "game";
}

void pauseGame()
{
	if(screenName == "pause")
		screenName = "game";
	else
		screenName = "pause";
}

void keyPressed() 
{
	if (key == 'q' || key == 'Q') 
	{
		players[0].ChangeDirection();
    }
	else if (key == 'v' || key == 'V') 
	{
		players[1].ChangeDirection();
    }
	else if (key == 'p' || key == 'P') 
	{
		players[2].ChangeDirection();
    }
	else if (key == ' ') 
	{
		if(screenName == "start")
			startGame();
		else if(screenName == "game")
			pauseGame();
		else if(screenName == "end")
			restartGame();
		else if(screenName == "pause")
			pauseGame();
    }
}

void mouseClicked() 
{
	if(screenName == "start")
		startGame();
	else if(screenName == "game")
	{
		//screenName = "pause";
		if(mouseX < screenWidth/3)
			players[0].ChangeDirection();
		else if (mouseX > 2*(screenWidth/3))
			players[2].ChangeDirection();
		else
			players[1].ChangeDirection();
	}
	else if(screenName == "end")
		restartGame();
	else if(screenName == "pause")
		pauseGame();
}

void createRandomLevel()
{
	gilTimes = new int[(int)random(1,3)];
	for (int i = 0; i < gilTimes.length; i++)
	{
		int timeSpacing = (int)(levelTimeout / (gilTimes.length + 1));
		gilTimes[i] = (i + 1) * timeSpacing;
	}

	// Objects
	for (int i = 0; i < 6; i++)
	{
		objects[i].CreateRandomTimes(levelTimeout);
	}
	
	// Stupid Guys
	for (int i = 0; i < stupidGuys.length; i++)
	{
		stupidGuys[i].CreateRandomTimes(levelTimeout);
	}
}

void updateScores()
{
	int winner = -1;
	if (players[0].Score > players[1].Score && players[0].Score > players[2].Score)
		winner = 0;
	else if (players[1].Score > players[0].Score && players[1].Score > players[2].Score)
		winner = 1;
	else if (players[2].Score > players[1].Score && players[2].Score > players[0].Score)
		winner = 2;
	
	if(winner != -1)
	{	
		overlays[6].AddToPlayer(players[winner]);
		overlays[6].UpdateImage();
		overlays[6].Hide();
	}
}

void updateBackground()
{
	background(255); 
	
	//Update sky
	if(skyY >= skyImg.height - height - skySpeed)
		skyY = 0;
	else
		skyY += skySpeed;     
	set(0, -skyY, skyImg);
	
	// Gil
	set(gilX, gilY,gilImg);
	
	//Update tower
	if(towerY >= towerImg.height - height - towerSpeed)
		towerY = 0;
	else
		towerY += towerSpeed;     
	set(0, -towerY, towerImg);
}

