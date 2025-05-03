public class Ground{
  private PImage ground;
  private int x;
  public Ground(){
    ground = loadImage("flappy_bird_ground.png");
    x=0;
  }
  public void show(){
    image(ground,x,660);
    image(ground,x+770,660);
  }
  public void update(){
    x-=1;
    if(x<= -400){
      x =0;
    }
  }
}
