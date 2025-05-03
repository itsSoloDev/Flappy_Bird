class Pipe{
  private Game game;
  private float x;
  private float y;
  private PImage top;
  private PImage bottom;
  private float speed;
  private int[] heights = new int[3];
  
  Pipe(float xPos){
    heights = new int[]{295,425,562};
    x = xPos;
    y = heights[(int)random(heights.length)];
    speed = 2;
    top = loadImage("topPipe.png");
    bottom = loadImage("bottomPipe.png");
  }
  
   public void show(){
     image(top,x,y-635);
     image(bottom,x,y);
   }
   
   public void update(){
     x-=speed;
     if(x<-80){
       startOver();
     }
   }
   
   public void startOver(){
     x=910;
     y= heights[(int)random(heights.length)];
   }
   
   public boolean touching(Bird bird){
    if(bird.getX() + 51 > x && bird.getX() < x + 80){
      if (!(bird.getY() + 38 < y && bird.getY() > y - 224)) {
        return true;
      }
    }
    return false;
  }
   
   
}
