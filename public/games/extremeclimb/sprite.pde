class Sprite 
{ 
  public PImage[] Frame;
  
  public int X = 0;
  public int Y = 0;
  public int Width = 50;
  public int Height = 50;
  
  public int PassesPerFrame = 20;
  public int Passes = 0;
  
  Sprite (String[] frameUri, int ppf)
  {  
    Frame = new PImage[frameUri.length];
    
    for(int i=0; i<frameUri.length; i++)
      Frame[i] = loadImage(frameUri[i]);
      
    X = 0;
    Y = 0;
    Width = Frame[0].width;
    Height = Frame[0].height;
    PassesPerFrame = ppf;
  } 
  
  public PImage CurrentFrame()
  {
    return Frame[(int)(Passes/PassesPerFrame)];
  }
    
  public void Update()
  {
    if (Passes < (Frame.length * PassesPerFrame)-1)
      Passes++;
    else
      Passes = 0;
      
    set(X,Y, CurrentFrame());
  }
  
  public void SetPosition(int x, int y)
  {
    X = x;
    Y = y;
  }
  
  public void SetSize(int wid, int hei)
  {
    Width = wid;
    Height = hei;
  }
}
