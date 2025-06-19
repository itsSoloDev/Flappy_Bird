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
    int BIRD_SIZE = 25;
    int PIPE_WIDTH = 59;
    int TOP_PIPE_HEIGHT = 410; // top pipe image height
    int PIPE_OFFSET_Y = 635;   // top pipe drawn at y - 635
    int margin = 2;
    int birdLeft   = (int)bird.x + margin;
    int birdRight  = (int)bird.x + BIRD_SIZE - margin;
    int birdTop    = (int)bird.y + margin;
    int birdBottom = (int)bird.y + BIRD_SIZE - margin;
    int pipeLeft  = (int)this.x;
    int pipeRight = pipeLeft + PIPE_WIDTH;
    boolean xOverlap = birdRight > pipeLeft && birdLeft < pipeRight;
    if (!xOverlap) return false;
        int topPipeBottom = (int)(this.y - PIPE_OFFSET_Y + TOP_PIPE_HEIGHT);
    int bottomPipeTop = (int)this.y;
    boolean hitsTopPipe = birdTop < topPipeBottom;
    boolean hitsBottomPipe = birdBottom > bottomPipeTop;
    return hitsTopPipe || hitsBottomPipe;
}

}
