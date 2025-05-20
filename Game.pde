////import java.util.List;
//import java.util.Map;
//import java.util.ArrayList;

class Game {
  private PImage background;
  private Ground ground;
  private Bird bird;
  private Pipe[] pipes = new Pipe[4];
  private boolean active;
  private float score;
  private PFont scoreFont;
  private float highScore;
  private PFont msgFont;
  private boolean paused = false;


  public Game() {
    background = loadImage("flappy-bird-background.png");
    ground = new Ground();
    bird = new Bird();
    active = true;
    score = 0;
    highScore = 0;
    msgFont= createFont("Lucida Console",20);
    scoreFont = createFont("PressStart2P-Regular.ttf", 18);
    for(int i=0;i<pipes.length;i++){
      pipes [i]= new Pipe(width + i * 250);
    }
  }

  public PImage getBackground() {
    return background;
  }

  // used to place images on the game window
  public void show() {
    for(Pipe p:pipes){
      p.show();
    }
    ground.show();
    if(active){
          bird.show();
     }
     showScore();
     //if (paused) {
     // fill(255, 255, 0);
     // textAlign(CENTER);
     // textSize(32);
     // text("Game Paused", width / 2, height / 2 - 100);
     // }
    }
  
  public void showScore(){
    textAlign(CENTER, CENTER);
    if(active){
      fill(0, 0, 0, 120);
      noStroke();
      textFont(scoreFont);
      fill(255);
      textAlign(LEFT, CENTER);
      text("Your Score: " + (int)score,35,50);
    }else{
       String msg = "Press ENTER to Play Again\n" +
                 "Press N to Enter New Name\n\n" +
                 "Press M to Enter the Home Menu\n"+
                 "High Score: " + (int)highScore + "\n" +
                 "Your Score: " + (int)score;
       textFont(msgFont);
      fill(255,0,0);
       textAlign(CENTER, CENTER);
      text(msg, width/2,height/2);
    }
  }
  
  public void updateScore(){
    score+=0.01;
  }
  
  public Bird getBird() {
    return bird;
  }

  public boolean isActive() {
    return active;
  }

  //used to update the position of image in the game window
  public void update() {
    ground.update();
  

    
    
    if(active){
      bird.update();
      if (bird.getY() >= 612) {
        gameOver();
      }
      updateScore();
    for(Pipe p: pipes){
      p.update();
        if(p.touching(bird)){
           gameOver();
        }
    }
    if(score >= 10){
      background = loadImage("flappy-bird-background2.jpg");
    }
  } 
}
  public void restart(){
    active = true;
    score = 0;
    background = loadImage("flappy-bird-background.png");
    bird.setY(80);
    bird.setVelocity(0);
    
     for (int i = 0; i < pipes.length; i++) {
      pipes[i] = new Pipe(width + i * 250);
    }
  }

 public void gameOver() {
    active = false;
    if(score>highScore){
      highScore = score;
    }
 }
 public void togglePause() {
  paused = !paused;
}
public boolean isPaused() {
  return paused;
}


}
