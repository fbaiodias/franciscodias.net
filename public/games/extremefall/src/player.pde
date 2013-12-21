class Player 
{ 
	public PImage Image;
	
	public int Frame = 0;
	
	public double X = 0;
	public double Y = 0;
	public double Width = 0;
	public double Height = 0;
	public double MaxX = 0;
	public double MaxY = 0;
	public double Speed = 30;

	public String Direction = "stop";

	public boolean Active = true;
	
	public boolean BubbleOn = false;
	public boolean GunOn = false;

	public int Score = 0;
	public int TotalScore = 0;
	
	public PImage LeftFrame;
	public PImage RightFrame;
        
	public PImage Left0Image;
	public PImage Left1Image;
	public PImage Right0Image;
	public PImage Right1Image;

	Player (String left0Uri, String left1Uri, String right0Uri, String right1Uri)
	{  
		Left0Image = loadImage(left0Uri);
		Left1Image = loadImage(left1Uri);
		Right0Image = loadImage(right0Uri);
		Right1Image = loadImage(right1Uri);
	} 
	
	public void UpdateFrames()
	{
		if (Frame < 3)
		{
			LeftFrame = Left0Image;
			RightFrame = Right0Image;

			Frame++;
		}
		else if (Frame < 6)
		{
			LeftFrame = Left1Image;
			RightFrame = Right1Image;

			Frame++;
		}
		else
		{
			Frame = 0;
		}
	}
	
	public void UpdateImage()
	{
		UpdateFrames();

		if (Direction == "left")
			Image = LeftFrame;
		else
			Image = RightFrame;
		
		set(X, Y, Image);
	}
	
	public void SetPosition(double x, double y)
	{
		X = x;
		Y = y;

		MaxX = X + Width;
		MaxY = Y + Height;
	}
	
	public void SetSize(double wid, double hei)
	{
		this.Width = wid;
		this.Height = hei;

		MaxX = X + Width;
		MaxY = Y + Height;
	}
	
	public void UpdatePosition(double speed)
	{
		if (Direction == "left")
			X -= speed;
		else if (Direction == "right")
			X += speed;

		MaxX = X + Width;
		MaxY = Y + Height;
	}
	
	
	public void ChangeDirection()
	{
		if (Direction == "right")
			Direction = "left";
		else
			Direction = "right";
	}

	public void Hide()
	{
		Active = false;
		X = -1000;
		Y = -1000;
	}
}

