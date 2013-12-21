class Player 
{ 
  public PImage Image;
  public PImage Frame0;
  public PImage Frame1;
  public PImage FrameJump;
  public PImage FrameHurt;
  
  public int HurtPoints = -10;
  public int AvoidPoints = 5;
  
  public int Frame = 0;
  
  public int X = 0;
  public int Y = 0;
  public int Width = 50;
  public int Height = 50;
  public int MaxX = 0;
  public int MaxY = 0;
  public int Speed = 30;
  public int VelocityX = 10;
  public int VelocityY = 10;
  public int OriginY = 0;

  public int HurtTime = 20;
  public int HurtTicks = 20;
  public int AvoidTime = 20;
  public int AvoidTicks = 20;

  public int JumpTime = 200;
  public int JumpTicks = 200;
  public int JumpSpeed = 40;
  int JumpAcceleration = 2;
  public boolean Active = true;
  public boolean Played = false;
  
  public int Score = 0;
  
  Player (String frame0Uri, String frame1Uri, String frameJumpUri, String frameHurtUri)
  {  
    Frame0 = loadImage(frame0Uri);
    Frame1 = loadImage(frame1Uri);
    FrameJump = loadImage(frameJumpUri);
    FrameHurt = loadImage(frameHurtUri);
  } 
  
  public void UpdateFrames()
  {
    if (Frame < 6)
    {
      Image = Frame0;
      Frame++;
    }
    else if (Frame < 12)
    {
      Image = Frame1;
      Frame++;
    }
    else
    {
      Frame = 0;
    }
  }
  
  public void UpdatePosition(long time)
  {
    if (JumpTicks < JumpTime)
    {
      if (Y <= OriginY)
      {
        Y = (int)(OriginY - (JumpSpeed * JumpTicks) + (0.5 * JumpAcceleration * JumpTicks * JumpTicks));
        JumpTicks++;
      }
      else
      {
        Y = OriginY;
        JumpTicks = JumpTime;
      }
    }
    
    if (HurtTicks < HurtTime)
      HurtTicks++;

    if (AvoidTicks < AvoidTime)
      AvoidTicks++;
    
    MaxX = X + Width;
    MaxY = Y + Height;
  }
  
  public void UpdateImage()
  {
    UpdateFrames();
    
    PFont fontA = loadFont("Arial");
    textFont(fontA, 40);
  
    if (JumpTicks < JumpTime)
    {
      Image = FrameJump;
    }
    
    if (AvoidTicks < AvoidTime)
    {
      fill(0,200,0);
      text("+5", X+(Width/2), Y-10);
    }
     
    if (HurtTicks < HurtTime)
    {
      Image = FrameHurt;
      fill(200,0,0);
      text("-10", X+(Width/2), Y-10);
    }
    set(X, Y, Image);
  }
  
  public void SetPosition(int x, int y)
  {
    OriginY = y;
    X = x;
    Y = y;

    MaxX = X + Width;
    MaxY = Y + Height;
  }
  
  public void SetSize(int wid, int hei)
  {
    this.Width = wid;
    this.Height = hei;

    MaxX = X + Width;
    MaxY = Y + Height;
  }
  
  public void Jump()
  {
    if (JumpTicks >= JumpTime)
    {
      JumpTicks = 0;
    }
    
    Played = true;
  }
  
  public void Hurt()
  {
    if (HurtTicks >= HurtTime)
    {
      HurtTicks = 0;
      Score += HurtPoints;
      AvoidTicks = AvoidTime;
    }
  }
  
  public void Avoid()
  {
    if (HurtTicks >= HurtTime && AvoidTicks >= AvoidTime)
    {
      AvoidTicks = 0;
      Score += AvoidPoints;
    }
  }
  
  public void Hide()
  {
    Active = false;
    X = -1000;
    Y = -1000;
    Score = 0;
  }
}
