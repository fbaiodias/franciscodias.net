class Overlay
{
	public PImage Image;

	public PImage Frame0Source;
	public PImage Frame1Source;

	public String Direction = "left";
	public String Mode = "timer";

	public int Frame = 0;
	public long Timeout = 100000;
	public int Wait = 100;
	public double X = 0;
	public double Y = 0;
	public double Width = 0;
	public double Height = 0;
	public double MaxX = 0;
	public double MaxY = 0;

	public boolean Active = false;

	public Overlay(String uri)
	{
		Frame0Source = loadImage(uri);
		Frame1Source = loadImage(uri);
		Image = Frame0Source;
	}

	public Overlay(String uri0, String uri1, String mode)
	{
		Frame0Source = loadImage(uri0);
		Frame1Source = loadImage(uri1);
		Image = Frame0Source;

		Mode = mode;
	}

	public void Update(long ticksTime)
	{
		if (ticksTime < Timeout)
		{
			//UpdateImage();
		}
		else
		{
			Hide();
		}
	}

	public void UpdateImage()
	{
		if (Mode == "timer")
		{
			if (Frame < 12)
			{
				Image = Frame0Source;
				Frame++;
			}
			else if (Frame < 24)
			{
				Image = Frame1Source;
				Frame++;
			}
			else
			{
				Frame = 0;
			}
		}
		else
		{
			if (Direction == "left")
				Image = Frame0Source;
			else
				Image = Frame1Source;
		}
		
		set(X, Y, Image);
	}

	public void AddToPlayer(Player player)
	{
		Active = true;
		
		X = player.X;
		Y = player.Y;
		Width = player.Width;
		Height = player.Height;
		MaxX = player.MaxX;
		MaxY = player.MaxY;

		Direction = player.Direction;
	}

	public void Hide()
	{
		Active = false;
		X = -1000;
		Y = -1000;
	}

}