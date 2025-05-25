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

boolean touching(Bird bird) {
    // Constants
    int BIRD_SIZE = 25;
    int PIPE_WIDTH = 59;
    int TOP_PIPE_HEIGHT = 410; // top pipe image height
    int PIPE_OFFSET_Y = 635;   // top pipe drawn at y - 635
    // Optional margin to reduce hitbox sensitivity (makes gameplay fairer)
    int margin = 2;
    // Bird bounding box
    int birdLeft   = (int)bird.x + margin;
    int birdRight  = (int)bird.x + BIRD_SIZE - margin;
    int birdTop    = (int)bird.y + margin;
    int birdBottom = (int)bird.y + BIRD_SIZE - margin;
    // Pipe bounding box
    int pipeLeft  = (int)this.x;
    int pipeRight = pipeLeft + PIPE_WIDTH;
    // 1. Check horizontal overlap
    boolean xOverlap = birdRight > pipeLeft && birdLeft < pipeRight;
    if (!xOverlap) return false;
    // 2. Calculate vertical positions of top and bottom pipes
    int topPipeBottom = (int)(this.y - PIPE_OFFSET_Y + TOP_PIPE_HEIGHT);
    int bottomPipeTop = (int)this.y;
    // 3. Check vertical collision:
    boolean hitsTopPipe = birdTop < topPipeBottom;
    boolean hitsBottomPipe = birdBottom > bottomPipeTop;

    return hitsTopPipe || hitsBottomPipe;
}

}
