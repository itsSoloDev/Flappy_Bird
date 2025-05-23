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
     if (speed < 6) {
        speed += 0.0005;  // Increase speed slowly over time
     }
     if(x<-80){
       startOver();
     }
   }
   public void startOver(){
     x=910;
     y= heights[(int)random(heights.length)];
   }
//  public boolean touching(Bird bird) {
//  float birdWidth = 45;   
//  float birdHeight = 34;  
//  float gapHeight = 200; 

//  if (bird.getX() + birdWidth > x && bird.getX() < x + 80) {
//    if (!(bird.getY() + birdHeight < y && bird.getY() > y - gapHeight)) {
//      return true;
//    }
//  }
//  return false;
//}


public boolean touching(Bird bird) {
  float birdX = bird.getX();
  float birdY = bird.getY();
  float birdWidth = 45;
  float birdHeight = 34;
  float pipeWidth = 80;
  float gap = 200;

  // Check horizontal overlap
  if (birdX + birdWidth > x && birdX < x + pipeWidth) {
    // Check vertical collision with top pipe or bottom pipe
    if (birdY < y - gap || birdY + birdHeight > y) {
      return true;
    }
  }
  return false;
}

}
