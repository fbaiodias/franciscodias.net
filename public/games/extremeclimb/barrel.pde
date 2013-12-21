class Barrel 
{ 
  public PImage Image;
  public PImage Frame0;
  public PImage Frame1;
  
  public int Frame = 0;
  
  public int X = 0;
  public int Y = 0;
  public int Width = 50;
  public int Height = 50;
  public int ScreenWidth = 1366;
  public int ScreenHeight = 768;
  public int MaxX = 0;
  public int MaxY = 0;
  public int Speed = 4;
  public int OriginY = 0;

  public float GroundM = 0;
  public int GroundB = 0;

  public int JumpTime = 200;
  public int JumpTicks = 200;
  public int JumpSpeed = 10;
  float JumpAcceleration = 1;
  public boolean Active = true;
  
  public int Score = 0;
  
  Barrel (String frame0Uri, String frame1Uri)
  {  
    Frame0 = loadImage(frame0Uri);
    Frame1 = loadImage(frame1Uri);
    
    GetRandomMovement();
  } 
  
  public void UpdateFrames()
  {
    if (Frame < 3)
    {
      Image = Frame0;
      Frame++;
    }
    else if (Frame < 6)
    {
      Image = Frame1;
      Frame++;
    }
    else
    {
      Frame = 0;
    }
  }
  
  public void GetRandomMovement()
  {
    Speed = (int)random(10,30);
    JumpSpeed = (int)random(10,30);
    JumpAcceleration = random(1,4);
  }
  
  public void UpdatePosition()
  {
    if(X < ScreenWidth)
    {
      if (JumpTicks < JumpTime)
      {
        if (Y <= GroundY())
        {
          Y = (int)(OriginY - (JumpSpeed * JumpTicks) + (0.5 * JumpAcceleration * JumpTicks * JumpTicks));
          JumpTicks++;
        }
        else
        {
          Y = GroundY();
          OriginY = GroundY();
          JumpTicks = 0;
        }
      }
      
      X += Speed;
      
      MaxX = X + Width;
      MaxY = Y + Height;
    }
    else
    {
      X = 0;
      Y = GroundY();
      OriginY = GroundY();
      JumpTicks = 0;
      GetRandomMovement();
    }
  }
  
  public void UpdateImage()
  {
    UpdateFrames();
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
  
  public void SetGround(int x1, int y1, int x2, int y2)
  {
    GroundM = (float)(y1 - y2) / (float)(x1 - x2);
    GroundB = (int)(y1 - GroundM * x1);
    OriginY = GroundY();
    JumpTicks = 0;
  }

  public int GroundY()
  {
    return (int)(GroundM * X + GroundB);
  }

  int GroundY(int x)
  {
    return (int)(GroundM * x + GroundB);
  }
  
  public void SetSize(int wid, int hei)
  {
    this.Width = wid;
    this.Height = hei;

    MaxX = X + Width;
    MaxY = Y + Height;
  }
  
  public void SetScreenSize(int wid, int hei)
  {
    this.ScreenWidth = wid;
    this.ScreenHeight = hei;
  }
  
  public void Hide()
  {
    Active = false;
    X = -1000;
    Y = -1000;
  }
}
