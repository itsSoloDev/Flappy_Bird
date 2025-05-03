class Bird{
  private PImage bird;
  private float x;
  private float y;
  private float gravity;
  private float velocity;
  
 
  
  Bird(){
    bird = loadImage("flappy_bird_icon.png");
    x = 70;
    y = 80;
    gravity = 0.1;
    velocity = 0;
  }
  
  public float getX(){
    return x;
  }
  
  public float getY(){
    return y;
  }
  
  public void setY(float newY){
    y = newY;
  }
  
  public void show() {
    pushMatrix();
    translate(x + bird.width / 2, y + bird.height / 2);
    float angle = map(velocity, -5, 5, radians(-10), radians(20)); // smaller rotation
    rotate(angle);
    imageMode(CENTER);
    image(bird, 0, 0);
    imageMode(CORNER);
    popMatrix();
  }

  
  public void flap(){
    velocity = 0;
    velocity -=2.5;
  }
  
  public void setVelocity(float newVelocity){
    velocity = newVelocity;
  }
  
  public void update(){
    velocity+=gravity;
    y+=velocity;
    y = constrain(y,0,612);
  }
}
