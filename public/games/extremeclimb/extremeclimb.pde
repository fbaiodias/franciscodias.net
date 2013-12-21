/* @pjs preload="assets/start.png, assets/end.png";  */
/* @pjs preload="assets/flats.png, assets/sky.png, assets/street.png";  */
/* @pjs preload="assets/barrel0.png, assets/barrel1.png";  */
/* @pjs preload="assets/playerOne0.png, assets/playerOne1.png, assets/playerOneJump.png, assets/playerOneHurt.png";  */
/* @pjs preload="assets/playerTwo0.png, assets/playerTwo1.png, assets/playerTwoJump.png, assets/playerTwoHurt.png";  */
/* @pjs preload="assets/playerThree0.png, assets/playerThree1.png, assets/playerThreeJump.png, assets/playerThreeHurt.png";  */
/* @pjs preload="assets/keyQ0.png, assets/keyQ1.png, assets/keyV0.png, assets/keyV1.png, assets/keyP0.png, assets/keyP1.png";  */

long time = 0;
Player[] player = new Player[3];
Barrel[] barrel = new Barrel[3];
Sprite[] keys = new Sprite[3];

PImage startImg;
PImage endImg;

PImage skyImg;
float skyX = 0;
float skyY = 0;
float skySpeed = 0.5;

PImage flatsImg;
float flatsX = 0;
float flatsY = 0;
float flatsSpeed = 1;

PImage streetImg;
float streetX = 0;
float streetY = 0;
float streetSpeed = 1.5;

int levelTimeout = 2000;
int playersTimeout = 200;
long ticksTime = 0;
int frame = 0;

int heightOffset = -200;

String screenName = "start";

boolean controlsHidden = true;
boolean stuffHidden = true;

int frame = 0;

PFont fontA;

void setup()
{
  size(1366,768);
  
  background(157,221,216);
  fill(222,249,247);
  fontA = loadFont("Arial");
  textFont(fontA, 120);
  text("Loading...", 350, 350);

  startImg = loadImage("assets/start.png");
  endImg = loadImage("assets/end.png");
  
  player[0] = new Player("assets/playerOne0.png", "assets/playerOne1.png", "assets/playerOneJump.png", "assets/playerOneHurt.png");
  player[1] = new Player("assets/playerTwo0.png", "assets/playerTwo1.png", "assets/playerTwoJump.png", "assets/playerTwoHurt.png");
  player[2] = new Player("assets/playerThree0.png", "assets/playerThree1.png", "assets/playerThreeJump.png", "assets/playerThreeHurt.png");
  for (int i=0; i < player.length; i++)
  {
    player[i].SetPosition(3*width/4 - (player.length-i)*50, 6*height/8 + (player.length-i)*25);
    player[i].SetSize(43,100);
  }

  for (int i=0; i < barrel.length; i++)
  {
    barrel[i] = new Barrel("assets/barrel0.png", "assets/barrel1.png");
    barrel[i].SetPosition(0, (height/2)-50);
    barrel[i].SetGround(0, height/2+50, width, height+50);
    barrel[i].SetSize(50,50);
    barrel[i].SetScreenSize(width,height);
  }
  
  flatsX = -width;
  flatsY = -height/2 + heightOffset;
  flatsImg = loadImage("assets/flats.png");
  
  skyX = -width;
  skyY = -height/2 + heightOffset;
  skyImg = loadImage("assets/sky.png");
  
  streetX = -width;
  streetY = -height/2;
  streetImg = loadImage("assets/street.png");
  
  String[] array = new String[]{"assets/keyQ0.png", "assets/keyQ1.png"};
  keys[0] = new Sprite (array, 10);
  array = {"assets/keyV0.png", "assets/keyV1.png"}
  keys[1] = new Sprite (array,10);
  array = {"assets/keyP0.png", "assets/keyP1.png"}
  keys[2] = new Sprite (array, 10);
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
    fill(0);
    textSize(40);
    text("Click to Play", 580,750);
  }
  else if(screenName == "game")
  {
    gameLoop();
  }
  else if(screenName == "end")
  {
    set(0, 0,endImg);
    
    textFont(fontA, 30);
    fill(200,200,0);
    if (player[0].Score > player[1].Score && player[0].Score > player[2].Score)
      text("WINNER!", 600, 700);
    else if (player[1].Score > player[0].Score && player[1].Score > player[2].Score)
      text("WINNER!", 1000, 440);
    else if (player[2].Score > player[1].Score && player[2].Score > player[0].Score)
      text("WINNER!", 1230, 700);
  }
}

void gameLoop()
{
  updateBackground();
   
  if(controlsHidden == true)
  {
    showControls();
    controlsHidden = false;
  }
  
  if(time < levelTimeout)
  {
    for (int i=0; i<(int)(time/(levelTimeout/3))+1; i++)
    {
      barrel[i].UpdatePosition();
      barrel[i].UpdateImage();
    
      for (int o=0; o<player.length; o++)
      {
        if(player[o].Active)
        {
          if(testCollision(player[o], barrel[i])) player[o].Hurt();
          if(testAvoid(player[o], barrel[i])) player[o].Avoid();
        }
      }
    }
  }
  else
  {
    for (int i=0; i<player.length; i++)
    {
      player[i].Y -= streetSpeed;
      player[i].X -= streetSpeed * 3.557;
    }
    
    if(player[0].X < 0)
      screenName = "end";
  }
    
  for (int i=0; i<player.length; i++)
  {
    if(player[i].Active)
    {
      player[i].UpdatePosition(time);
      player[i].UpdateImage();
    }
    
    if (time > playersTimeout && !player[i].Played)
      player[i].Hide();
      
    if (time < playersTimeout && !player[i].Played)
    {
      noStroke();
      if(i == 0) 
        fill(83,121,35,50);
      else if(i == 1) 
        fill(198,100,146,50);
      else if(i == 2) 
        fill(54,131,197,50);
      rect(i*(width/3), 0, width/3, height);
    }
  }
  
  for (int i=0; i<player.length; i++)
  {
    if(time < playersTimeout && !player[i].Played)
    {
      keys[i].SetPosition(player[i].X-20, player[i].Y);
      keys[i].Update();
    }
  }
  //  Update TextBlocks
  printMessage("<b>Player One:</b> " + str(player[0].Score) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Player Two:</b>  " +str(player[1].Score) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Player Three:</b>  " +str(player[2].Score));
  
  
  time++;
}

void startGame()
{
  screenName = "game";
}

void pauseGame()
{
  if(screenName == "pause")
    screenName = "game";
  else
    screenName = "pause";
}

void restartGame()
{
  // Restart Players Variables
  for (int i = 0; i < player.length; i++)
  {
    player[i].Active = true;
    player[i].Played = false;
    player[i].Score = 0;
    player[i].SetPosition(3*width/4 - (player.length-i)*50, 6*height/8 + (player.length-i)*25);
  }
  
  time = 0;
  
  screenName = "game";
}


void mouseClicked() 
{
  if(screenName == "start")
    startGame();
  else if(screenName == "game")
  {
    if(mouseX < width/3)
      player[0].Jump();
    else if (mouseX > 2*(width/3))
      player[2].Jump();
    else
      player[1].Jump();
  }
  else if(screenName == "end")
    restartGame();
  else if(screenName == "pause")
    pauseGame();
}

void keyTyped()
{
  if(key == 'q' || key == 'Q')
    player[0].Jump();
  if(key == 'v' || key == 'V')
    player[1].Jump();
  if(key == 'p' || key == 'P')
    player[2].Jump();
}

boolean valueInRange(int value, int min, int max)
{ 
  return (value >= min) && (value <= max); 
}

boolean testCollision(Player p, Barrel b)
{
    boolean xOverlap = valueInRange(p.X, b.X, b.X + b.Width) ||
                    valueInRange(b.X, p.X, p.X + p.Width);

    boolean yOverlap = valueInRange(p.Y, b.Y, b.Y + b.Height) ||
                    valueInRange(b.Y, p.Y, p.Y + p.Height);

    return xOverlap && yOverlap;
}

boolean testAvoid(Player p, Barrel b)
{
    boolean xOverlap = valueInRange(p.X, b.X, b.X + b.Width) ||
                    valueInRange(b.X, p.X, p.X + p.Width);

    boolean yOverlap = valueInRange(p.Y, b.Y, b.Y + b.Height) ||
                    valueInRange(b.Y, p.Y, p.Y + p.Height);

    return xOverlap && !yOverlap;
}

void updateBackground()
{
  background(83,125,40); 
  
  //Update flats
  if(flatsX + flatsSpeed > 0)
  {
    flatsX = -width;
    flatsY = -height/2 + heightOffset;
  }
  else
  {
    flatsY += flatsSpeed;   
    flatsX += flatsSpeed * 3.557;     
  }
  
  //Update sky
  if(skyX + skySpeed > 0)
  {
    skyX = -width;
    skyY = -height/2 + heightOffset;
  }
  else
  {
    skyY += skySpeed;   
    skyX += skySpeed * 3.557;     
  }
  
  //Update street
  if(streetX + streetSpeed > 0)
  {
    streetX = -width;
    streetY = -height/2;
  }
  else
  {
    streetY += streetSpeed;   
    streetX += streetSpeed * 3.557;     
  }
  
  set(skyX, skyY, skyImg);
  set(flatsX, flatsY, flatsImg);
  set(streetX, streetY, streetImg);
}
