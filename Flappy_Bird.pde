import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;
import processing.sound.*;
import javax.swing.JOptionPane;
import de.bezier.data.sql.SQLite;
import de.bezier.data.sql.MySQL;


SQLite db;

SoundFile soundFile;
SoundFile flapSound;
SoundFile crashSound;
SoundFile clickSound;
PFont arcadeFont;
PImage menuBackground;
PFont nameFont;
PFont settingsFont;


Game game;

String gameState = "name";
boolean soundOn = true;
String username = "";
boolean askingName = true;
boolean scoreSaved = false;
void setup() {
  size(400, 719);
  game = new Game();
  db = new SQLite(this, "flappy.db");
  arcadeFont = createFont("PressStart2P-Regular.ttf", 16);
  nameFont = createFont("Segoe UI Bold", 28);
  settingsFont = createFont("Lucida Console", 36);
  menuBackground = loadImage("main-menu.jpg");
  textFont(arcadeFont);
  soundFile = new SoundFile(this, "extremeaction.mp3");
  flapSound = new SoundFile(this, "flapSound.mp3");
  crashSound = new SoundFile(this, "crashSound.mp3");
  clickSound = new SoundFile(this, "clickSound.mp3");
  if (soundOn) {
  soundFile.loop();
  soundFile.amp(0.3);
  clickSound.amp(1.0);
}
   if (db.connect()) {
    String createTable = 
      "CREATE TABLE IF NOT EXISTS flappy_scores (" +
      "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
      "player_name TEXT, " +
      "score INTEGER, " +
      "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
      
    db.query(createTable);
    println("Table ready!");
  }
}

void saveScore(String playerName, int score) {
  if (playerName == null || playerName.trim().equals("")) {
    println("Invalid player name. Not saving score.");
    return;
  }

  if (!db.connect()) {
    println("DB connection failed during save.");
    return;
  }
  // Escape any single quotes inside player name to avoid SQL injection errors
  playerName = playerName.replace("'", "''");
  // Check if player already exists
  db.query("SELECT * FROM flappy_scores WHERE player_name = '" + playerName + "'");
  if (db.next()) {
    int existingScore = db.getInt("score");
    if (score > existingScore) {
      // Update the score
      String updateQuery = "UPDATE flappy_scores SET score = " + score +  " WHERE player_name = '" + playerName + "'";
      db.execute(updateQuery);
      println("Updated high score for " + playerName + ": " + score);
      JOptionPane.showMessageDialog(null, "🎉 New High Score! 🎮\n" + playerName + ": " + score, "High Score!", JOptionPane.INFORMATION_MESSAGE); 
  } else {
      println("No update needed. Existing score (" + existingScore + ") is higher or equal.");
    }
  } else {
    // Insert new player
    String insertQuery = "INSERT INTO flappy_scores (player_name, score) VALUES ('" + playerName + "', " + score + ")";
    db.execute(insertQuery);
    println("Inserted new player: " + playerName + " with score: " + score);
    JOptionPane.showMessageDialog(null, "🎉 Welcome! First Score Saved!\n" + playerName + ": " + score, "Score Saved!", JOptionPane.INFORMATION_MESSAGE);
  }
}
void showHighScores() {
  if (!db.connect()) return;
  db.query("SELECT 
  player_name, MAX(score) 
  AS score FROM flappy_scores GROUP BY player_name ORDER BY score DESC LIMIT 10");
  int y = 100;
  textSize(24);
  fill(255);
  text("High Scores", 50, 50);

  while (db.next()) {
    String name = db.getString("player_name");
    int score = db.getInt("score");
    text(name + ": " + score, 50, y);
    y += 40;
  }
}  

void drawHighScoreScreen() {
  if (!db.connect()) return;

  background(0);
  textFont(arcadeFont);
  textAlign(CENTER, CENTER);

  fill(255, 215, 0); // Gold
  textSize(36);
  text("🏆 HIGH SCORES 🏆", width / 2, 60);

  db.query("SELECT player_name, score FROM flappy_scores ORDER BY score DESC LIMIT 10");


  int y = 140;
  int rank = 1;

  while (db.next()) {
    String name = db.getString("player_name");
    int score = db.getInt("score");
    println("Row: " + name + " - " + score); // Debug
    if (rank == 1) fill(255, 0, 0);        // Red for 1st
    else if (rank == 2) fill(255, 140, 0); // Orange for 2nd
    else if (rank == 3) fill(255, 255, 0); // Yellow for 3rd
    else fill(200);                       // Grey for others

    textSize(24);
    text(rank + ". " + name + " - " + score, width / 2, y);
    y += 50;
    rank++;
  }
  // Draw "Back" instruction
  fill(255);
  textSize(16);
  text("Press B to return to Menu", width / 2, height - 50);
}
void drawNameScreen() {
  background(20, 20, 50); // Dark blue arcade feel

  textFont(arcadeFont);
  textAlign(CENTER, CENTER);
  // "Enter Your Name" title
  fill(255, 255, 0); // Bright yellow
  textSize(24);
  text("ENTER YOUR NAME", width / 2, height / 2 - 120);
  // Name input box
  float boxWidth = width * 0.6; // 60% of canvas width
  float boxHeight = 50;
  fill(0);
  stroke(255);
  strokeWeight(3);
  rectMode(CENTER);
  rect(width / 2, height / 2, boxWidth, boxHeight); // Properly sized box
  // Username text inside box
  fill(255);
  textSize(20);
  text(username + getBlinkingCursor(), width / 2, height / 2);
  // Instruction
  textSize(12);
  fill(200);
  text("Press ENTER when done", width / 2, height / 2 + 100);
}
// Helper to create blinking cursor
String getBlinkingCursor() {
  if (millis() % 1000 < 500) {
    return "_";
  } else {
    return " ";
  }
}
void draw() {
  if (gameState.equals("name")) {
    drawNameScreen();
  } else if (gameState.equals("menu")) {
    drawMenu();
  } else if (gameState.equals("Play")) {
    background(game.getBackground());
    game.show();

    if(!game.paused){
      game.update();
    }
    if (game.paused) {
    rectMode(CORNER); // Top-left origin, default mode
    fill(0, 0, 0, 150); // Transparent black overlay
    rect(0, 0, width, height);
    fill(255); // White text
    textFont(arcadeFont);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("⏸️ GAME PAUSED ⏸️", width/2, height/2);
}
    if (!game.isActive() && !scoreSaved) {
        saveScore(username, (int)game.score); // Save the score once
        scoreSaved = true;
        println("Score saved: " + username + " - " + (int)game.score);
    }

  } else if (gameState.equals("Settings")) {
    drawSettings();
  }else if (gameState.equals("HighScore")) {
  drawHighScoreScreen();
}
}
void drawMenu() {
  background(135, 206, 235);
  image(menuBackground, 0, 0, width, height);

  fill(255);
  textFont(arcadeFont);
  textAlign(CENTER, CENTER);

  // Title
  textSize(35);
  text("FLAPPY BIRD", width/2, 80); // Slightly higher

  // Draw buttons using new centered system
  drawButton(width/2, 200, 250, 60, "START");
  drawButton(width/2, 300, 250, 60, "SETTINGS");
  drawButton(width/2, 400, 250, 60, "QUIT");
  drawButton(width/2, 500, 250, 60, "HIGH SCORE");
  // Helper text
  textSize(18);
  fill(255);
  text("Click to select", width/2, height - 40);
}
void drawButton(float centerX, float centerY, float w, float h, String label) {
  rectMode(CENTER);
  stroke(0);
  strokeWeight(4);
  fill(255, 100, 0); // classic arcade orange
  rect(centerX, centerY, w, h, 12); // Centered rectangle

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(24);
  text(label, centerX, centerY); // Text centered exactly
}
void drawSettings() {
  background(50);
  textAlign(CENTER, CENTER);
  fill(255);
  textFont(settingsFont);
  fill(255);
  text("Settings Menu", width / 2, 100);
  textSize(20);
  textFont(createFont("Lucida Console", 20));
  text("Press B to go back", width / 2, 200);
  text("Press M to toggle music", width / 2, 240);
  fill(soundOn ? color(0, 255, 0) : color(255, 0, 0));
  text("Sound: " + (soundOn ? "On" : "Off"), width / 2, 280);
}

void keyPressed() {
  if (key == ESC) {
    key = 0; // prevent exiting Processing
    if (gameState.equals("Play")) {
      game.paused = !game.paused; // toggle pause
      println(game.paused ? "Game Paused" : "Game Resumed");
    }
    return;
  }

  if (gameState.equals("name")) {
    if (key == ENTER || key == RETURN) {
      if (username.length() > 0) {
        gameState = "menu";
      }
    } else if (key == BACKSPACE) {
      if (username.length() > 0) {
        username = username.substring(0, username.length() - 1);
      }
    } else if (key != CODED && username.length() < 12) {
      username += key;
    }
  } else if (gameState.equals("Play")) {
    if (key == ' ') {
      if (game.isActive()) {
        game.getBird().flap();
        if (soundOn) flapSound.play();
      }
    }
    else if (!game.isActive()) {
      if (key == ENTER || key == RETURN) {
        game.restart();
        scoreSaved = false;
        println("Game restarted with ENTER");
      }else if (key == 'n' || key == 'N') {
        gameState = "name";
        username = ""; // reset username if you want
        game = new Game(); // ✨ restart the game fully
        gameState = "name"; 
        scoreSaved = false; // ✨ reset score saved flag
        println("New player! Going to name screen.");
      }else if (key == 'm' || key == 'M'){
        gameState = "menu";
        game = new Game();
        scoreSaved = false;
      }
    }
  }else if (gameState.equals("Settings")) {
    if (key == 'b' || key == 'B') {
      gameState = "menu";
    } else if (key == 'm' || key == 'M') {
      soundOn = !soundOn;
      println("Sound toggled: " + soundOn);
      if (soundOn) {
        soundFile.loop();
      } else {
        soundFile.stop();
      }
    }
  } else if (gameState.equals("HighScore")) {
    if (key == 'b' || key == 'B') {
      gameState = "menu";
    }
  }
}


void mousePressed() {
  if (gameState.equals("menu")) {
    
    if (overButton(width/2, 200, 250, 60)) {
      clickSound.play();
      gameState = "Play"; // START
    } else if (overButton(width/2, 300, 250, 60)) {
      clickSound.play();
      gameState = "Settings"; // SETTINGS
    } else if (overButton(width/2, 400, 250, 60)) {
      exit(); // QUIT
    } else if (overButton(width/2, 500, 250, 60)) {
      gameState = "HighScore"; // HIGH SCORE
      clickSound.play();
    }
  } else if (gameState.equals("HighScore")) {
    gameState = "menu"; // Go back to menu on click
    clickSound.play();
  }
}



boolean overButton(float centerX, float centerY, float w, float h) {
  return mouseX > centerX - w/2 && mouseX < centerX + w/2 &&
         mouseY > centerY - h/2 && mouseY < centerY + h/2;
}
