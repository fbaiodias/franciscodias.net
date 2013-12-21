class StupidGuy 
{
	public PImage Image;

	public String Type = "";
	public String Direction = "stop";

	public int[] Times;
	public int MinTimes = 0;
	public int MaxTimes = 5;

	public long Timeout = 100000;
	public int Wait = 100;
	public int Time = 100;

	public double MinX = 0;
	public double MaxX = 0;
	public double X = 0;
	public double Y = 0;
	public double Width = 0;
	public double Height = 0;
	public double SpeedX = 5;
	
	public boolean Active = false;

	double ScreenWidth = 1366;
	double ScreenHeight = 768;
	double ResolutionRatio = 1;
	
	public StupidGuy(String uri, int minTimes, int maxTimes, double minX, double maxX, int time, String type)
	{
		Image = loadImage(uri);
		
		MinTimes = minTimes;
		MaxTimes = maxTimes;

		Type = type;

		Time = time;
	}

	public StupidGuy(String uri, int minTimes, int maxTimes, int time, String type)
	{
		Image = loadImage(uri);

		MinTimes = minTimes;
		MaxTimes = maxTimes;

		Type = type;

		Time = time;
	}
	
	public void CreateRandomTimes(int levelTimeout)
	{
		Times = new int[(int)random(MinTimes, MaxTimes)];

		if (Times.length == 1)
			Times[0] = random(100, 800);
		else if (Times.length > 1)
		{
			Times[0] = random(100, levelTimeout - Times.length * 200);

			for (int i = 1; i < Times.length; i++)
			{
				Times[i] = random(Times[i - 1] + 200, levelTimeout - (Times.length - i) * 200);
			}
		}
	}
	
	public void SetScreenSize(double wid, double hei, double resolutionRatio)
	{
		ScreenWidth = wid;
		ScreenHeight = hei;

		ResolutionRatio = resolutionRatio;
	}

	public void Update(long ticksTime)
	{
		if (Type == "zeca")
		{
			for (int i=0; i < Times.length; i++)
			{
				if (Times[i] > ticksTime && Times[i] < ticksTime + 2)
				{  
					Timeout = ticksTime + Time;

					Y = ScreenHeight - Height - 50;
					X = -Width;

					Active = true;

					Direction = "right";
				}
				else if (ticksTime == Timeout)
				{
					Direction = "left";
				}
			}

			if ((X + Width > 150 + 100 && Direction == "right") || (X < -Width && Direction == "left"))
				Direction = "stop";

			if (Direction == "right")
				X += SpeedX * ResolutionRatio;
			else if (Direction == "left")
				X -= SpeedX * ResolutionRatio;
		}
		else if (Type == "nuno")
		{
			for (int i=0; i < Times.length; i++)
			{
				if (Times[i] > ticksTime && Times[i] < ticksTime + 2)
				{
					Timeout = ticksTime + Time;

					Y = ScreenHeight - Height - 50;
					X = ScreenWidth;

					Active = true;

					Direction = "left";
				}
				else if (ticksTime == Timeout)
				{
					Direction = "right";
				}
			}

			if ((X < ScreenWidth - 150 - 100 && Direction == "left") || (X > ScreenWidth && Direction == "right"))
				Direction = "stop";

			if (Direction == "right")
				X += SpeedX * ResolutionRatio;
			else if (Direction == "left")
				X -= SpeedX * ResolutionRatio;
		}
		else if (Type == "fred")
		{
			for (int i=0; i < Times.length; i++)
			{
				if (Times[i] > ticksTime && Times[i] < ticksTime + 2)
				{
					Timeout = ticksTime + Time;

					Y = 50;
					X = ScreenWidth;

					Active = true;

					Direction = "left";
				}
				else if (ticksTime == Timeout)
				{
					Direction = "right";
				}
			}

			if ((X < ScreenWidth - 150 - 100 && Direction == "left") || (X > ScreenWidth && Direction == "right"))
				Direction = "stop";

			if (Direction == "right")
				X += SpeedX * ResolutionRatio;
			else if (Direction == "left")
				X -= SpeedX * ResolutionRatio;
		}
	}
	
	public void UpdateImage()
	{
		set(X, Y, Image);
	}

	public void SetSize(int wid, int hei)
	{
		Width = wid;
		Height = hei;
	}

	public void Hide()
	{
		Active = false;
		X = -1000;
		Y = -1000;
	}


	
}