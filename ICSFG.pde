/*
PENGUIN VS PACMAN
 BY: NOAH AND ARYAN
 HOPE YOU ENJOY :D
 
 
 

                         4MMMMMMMMMMMML
                       4MMMMMMMMMMMMMMMML
                      MMMMMMMMMMMMMMMMMMML
                     4MMMMMMMMMMMMMMMMMMMMM
                    4MMMMMMMMMMMMMMMMMMMMMML
                    MMMMP   MMMMMM   MMMMMMM
                    MMMM MM  MMM  MM  MMMMMM
                    MMMM MM  MMM  MM  MMMMML
                     MMM MP,,,,,,,MM  MMMMMM
                      MM,"          "MMMMMMP
                      MMw           'MMMMMM
                      MM"w         w MMMMMMML
                      MM" w       w " MMMoMMML
                     MMM " wwwwwww "  MMMMMMML
                   MMMP   ".,,,,,,"     MMMMMMMML
                  MMMP                    MMMMMMMML
                MMMMM                      MMMMMMMML
               MMMMM,,-''             ''-,,MMMMMMMMML
              MMMMM                          MMMMMMMMML
             MMMMM                            MMMMMMMMML
            MMMMM                             MMMMMMMMMM
            MMMM                               MMMMMMMMMM
           MMMMM                               MMMMMMMMMML
          MMMMM                                MMMMMMMMMMM
         MMMMMM                                MMMMMMMMMMM
         MMMMMMM                               MMMMMMMMMMM
         """"MMMM                             MMMMMMMMMMP
        "     ""MMM                            MMMMMMMMP
   "" "         "MMMMMM                      """"MMMMMP"""
 "               "MMMMMMM                   ""   """"""   "
 "                ""MMMMMM                 M"             " ""
  "                 "                   MMM"                  "
 "                   "M               MMMM"                   "
 "                    "MM        MMMMMMMMM"                ""
 "                    "MMMMMMMMMMMMMMMMMMM"              """
  """"                "MMMMMMMMMMMMMMMMMM"           """"
      """"""""       MMMMM               "        ""
              """"""""                      """"""" 
              
 */
boolean alive;
int[] pacX;
int[] pacY;
int penY;
int penX;
int penYS;
int penXS;
int[] pacXS;
int[] pacYS;
boolean [] pacT;
Timer gameTimer;
Timer abilityTimer;
boolean canUse;
int dmg;
float hue;
int squareSize = 20;
float [] squareX, squareY;
float speed = 2.5;
boolean [] isTouching;
float [] angle;
float [] distance;
boolean won;
int endTime = 0;
int opacity = 0;
boolean replay = false;
boolean lost;
boolean boss;
float bossX, bossY;
float bossS = 50;
float bossSp;
boolean bossT = false;
float borderHue = 0; // Hue for background
int borderWidth = 2; // Width of the border
boolean intro;
PImage penguinImage;
PImage pacmanImage;
PImage bossImage;
boolean settings;
boolean tMode;

// audio libraries
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer wins;
AudioPlayer lose;
AudioPlayer bossM;
AudioPlayer BGM;
AudioPlayer introM;

void setup() {
  // initialize all variables
  settings = false;
  tMode = false;
  intro = true;
  minim = new Minim(this);
  wins = minim.loadFile("win.mp3");
  lose = minim.loadFile("lose.mp3");
  bossM = minim.loadFile("boss.mp3");
  BGM = minim.loadFile("background.mp3");
  introM = minim.loadFile("intro.mp3");
  bossX=-bossS;
  bossY = random(40, height - 40);
  fullScreen();
  frameRate(120);
  lost = false;
  squareX = new float[4];
  squareY = new float[4];
  alive = true;
  pacX = new int[4];
  pacY = new int[4];
  pacXS = new int[4];
  pacYS = new int[4];
  pacT = new boolean[4];
  penY = int(random(40, height - 40));
  penX = int(random(40, width - 40));
  penYS = 3;
  penXS = 3;
  bossSp= 2.9;
  dmg = 3;
  canUse = true;
  gameTimer = new Timer(3*60);
  abilityTimer = new Timer(10);
  colorMode(HSB, 360, 100, 100);
  hue = 0;
  pacT[0]=true;
  isTouching = new boolean[4];
  distance = new float[4];
  angle = new float[4];
  won = false;
  replay = false;
  for (int i = 0; i < pacX.length; i++) {
    pacX[i] = -100;
    pacY[i] = -100;
  }

  penguinImage = loadImage("penguin.png");
  penguinImage.resize(100, 100); // Resize penguin image to 100x100

  pacmanImage = loadImage("pacman.png");
  pacmanImage.resize(125, 125); // Resize Pac-Man image to 125x125

  bossImage = loadImage("pacman.png");
  bossImage.resize(200, 200); // Resize boss image to 200x200
}

void draw() {

  if (intro == false) {
    introM.rewind();
    BGM.play();
    strokeWeight(5);
    if (lost) {
      Lose();
      return; // Prevents rest of code if lost
    }
    //all functions
    backgroundC();
    boarder();
    drawPen();
    visuals();
    pac();
    pacLogic();
    logic();

    // boss and win logic based off of timers
    if (gameTimer.timeLeft() <= 77) {
      boss = true;
      boss();
    }
    if (gameTimer.isFinished()) {
      won();
      for (int i = 0; i < pacXS.length; i++) {
        pacXS[i] = 0;
        pacYS[i] = 0;
      }
    }

    if (keyPressed) {
      handleKeyPress();
    }
  } else {
    intro();
  }
  if (settings) {
    setting();
  }
}

void intro() {
  // intro screen
  introM.play();
  background(0);
  textAlign(CENTER);
  textSize(50);
  text("Welcome to PENGUIN V PACMAN", width/2, 200);
  textSize(30);
  text("You're playing as a penguin who is running from the killer, PACMAN. Use WASD to control the penguin and try your best to escape from pacman! You have to survive 3 minutes and run away from PACMAN. You have a special ability that pacman does not have. You can go through walls and go to the other side. Use this to your advantage when you're running away from him. You can use this ability every 10 second so use it wisely! lso, make sure to watch out for other pacman because they spawn every 30 seconds. Also, at the last minute, there will be a very fun surprise so watch out for that! Anyways, enjoy the game and thank you for playing!                            Click anywhere to continue. Press S to open settings", 200, 400, width-400, height-400) ;
}
void boss() {
  // boss
  noStroke();
  if (bossT) {
    dmg--;
    bossX = width / 2;
    bossY = width / 2;
  }
  BGM.rewind();
  bossM.play();
  // calculate angle differences between pen and boss
  float angle = atan2(penY - bossY, penX - bossX);
  bossX += cos(angle) * bossSp;
  bossY += sin(angle) * bossSp;
  imageMode(CENTER);
  image(bossImage, bossX, bossY);
  // calculate distance between boss
  float distance = dist(penX, penY, bossX, bossY);
  if (distance < bossS / 2) {
    bossT = true;
  } else {
    bossT = false;
  }
}
// keypresses
void handleKeyPress() {
  if (key == 'W' || key == 'w') {
    penY -= penYS;
  }
  if (key == 'S' || key == 's') {
    penY += penYS;
  }
  if (key == 'D' || key == 'd') {
    penX += penXS;
  }
  if (key == 'A' || key == 'a') {
    penX -= penXS;
  }
}

// draw pacmans
void pac() {
  for (int i = 0; i < pacX.length; i++) {
    if (pacT[i]) {
      imageMode(CENTER);
      image(pacmanImage, pacX[i], pacY[i]); // pacman image
    }
  }
}



void pacLogic() {
  noStroke();
  // pacman logic
  float minDistance = squareSize * 2;

  for (int i = 0; i < squareX.length; i++) {
    if (gameTimer.elapsedTime() > i * 30) {
      if (isTouching[i]) {
        dmg--;
        squareX[i] = width / 2;
        squareY[i] = width / 2;
      }

      angle[i] = atan2(penY - squareY[i], penX - squareX[i]);
      squareX[i] += cos(angle[i]) * speed;
      squareY[i] += sin(angle[i]) * speed;

      // Draw Pacman image
      imageMode(CENTER);
      image(pacmanImage, squareX[i], squareY[i]);

      distance[i] = dist(penX, penY, squareX[i], squareY[i]);
      isTouching[i] = distance[i] < squareSize / 2;
    }
  }

  // pacman chase logic
  for (int i = 0; i < squareX.length; i++) {
    for (int j = i + 1; j < squareX.length; j++) {
      if (gameTimer.elapsedTime() > i * 30 && gameTimer.elapsedTime() > j * 30) {
        float distBetweenSquares = dist(squareX[i], squareY[i], squareX[j], squareY[j]);
        if (distBetweenSquares < minDistance) {
          float angleBetween = atan2(squareY[j] - squareY[i], squareX[j] - squareX[i]);
          float overlap = minDistance - distBetweenSquares;
          squareX[i] -= cos(angleBetween) * overlap / 2;
          squareY[i] -= sin(angleBetween) * overlap / 2;
          squareX[j] += cos(angleBetween) * overlap / 2;
          squareY[j] += sin(angleBetween) * overlap / 2;
        }
      }
    }
  }
}


void visuals() {
  // Other visual elements
  textAlign(CORNER);
  textSize(15);
  fill(0); // Default fill color for other texts
  text("HP: " + dmg, 20, 60);
  if (canUse) {
    text("Can use ability", 20, 20);
  } else {
    text("Can use ability in: " + abilityTimer.timeLeft() + " Seconds", 20, 20);
  }
  text("You'll win in: " + gameTimer.timeLeft() + " Seconds", 20, 40);

  // Countdown text with gray color and 50% opacity
  if (gameTimer.timeLeft() <= 10) {
    textAlign(CENTER);
    colorMode(RGB);
    fill(128, 128, 128, 127); // Semi-transparent gray
    textSize(70);
    text(gameTimer.timeLeft(), width / 2, height / 2);
    colorMode(HSB, 360, 100, 100); // Reset color mode if needed elsewhere
  }
}


void logic() {

  if (dmg<=0) {
    won = false;
    lost = true;
  }
  if (canUse) {
    // logic for ability
    if (penX > width) {
      penX = 0;
      canUse = false;
      abilityTimer.reset();
    } else if (penX < 0) {
      penX = width;
      canUse = false;
      abilityTimer.reset();
    }
    if (penY > height) {
      penY = 0;
      canUse = false;
      abilityTimer.reset();
    } else if (penY < 0) {
      penY = height;
      canUse = false;
      abilityTimer.reset();
    }
  } else {
    if (penX >= width - 20) {
      penX = width - 20;
    } else if (penX <= 20) {
      penX = 20;
    }
    if (penY >= height - 20) {
      penY = height - 20;
    } else if (penY <= 20) {
      penY = 20;
    }
    if (abilityTimer.isFinished()) {
      canUse = true;
    }
  }

  if (gameTimer.isFinished()) {
    // if game timer is finished
    won();
  }
}

void backgroundC() {
  // background color
  hue += 0.1;
  if (hue > 360) {
    hue = 0;
  }
  background(hue, 80, 50);
}

void drawPen() {
  // draw penguin
  imageMode(CENTER);
  image(penguinImage, penX, penY);
}
// win screen
void won() {
  noStroke();
  won = true;
  lost = false;
  if (!replay) {
    wins.rewind();
    wins.play();
    replay = true;  // Set to true immediately after playing the sound
    endTime = millis();
    opacity = 0;
  }

  if (millis() > endTime + 2000 && opacity < 255) {
    opacity++;
  }

  // Drawing the win screen
  background(0);
  textSize(50);
  textAlign(CENTER);
  colorMode(RGB);
  fill(0, 255, 0);
  text("YOU ESCAPED PACMAN THE PENGUIN HUNTER", width/2, height/2);

  // Play again button and text
  PAButton();
}

void Lose() {
  noStroke();
  BGM.rewind();
  bossM.rewind();
  won = false;
  lost = true;
  if (!replay) {
    lose.rewind();
    lose.play();
    replay = true;  // Set to true immediately after playing the sound
    endTime = millis();
    opacity = 0;
  }

  if (millis() > endTime + 2000 && opacity < 255) {
    opacity++;
  }

  // Drawing the lose screen
  background(0);
  textSize(50);
  textAlign(CENTER, CENTER);
  colorMode(RGB);
  fill(255, 0, 0);
  text("RED IS THE COLOR OF DEAD PENGUINS", width / 2, height / 2);

  // Play again button and text
  PAButton();
}

void PAButton() {
  // Button
  fill(255, opacity);
  rectMode(CENTER);
  rect(width / 2, height / 2 + 100, 200, 60, 10);

  // Text
  fill(0, opacity);
  textSize(32);
  text("Play Again", width / 2, height / 2 + 100);
}

// Button Logic
void playAgain() {
  if (opacity < 255) {
    opacity++;
  }

  // Button
  fill(255, opacity);
  rectMode(CENTER);
  rect(width/2, height/2 + 100, 200, 60, 10);

  // Text
  fill(0, opacity);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Play Again", width/2, height/2 + 100);
  won = true;
}


void mousePressed() {
  if (intro) {
    intro = !intro;
  }
  if (won || lost) {
    // Calculate the button's position dynamically
    int buttonX = width / 2 - 100;
    int buttonY = height / 2 + 70;
    int buttonWidth = 200;
    int buttonHeight = 60;

    // Check if the mouse click is within the bounds of the button
    if (mouseX > buttonX && mouseX < buttonX + buttonWidth &&
      mouseY > buttonY && mouseY < buttonY + buttonHeight) {
      resetGame();
    }
  }
}


// reset the game to ensure eveyrthing works propperly
void resetGame() {
  if (bossM.isPlaying()) {
    bossM.pause();
    bossM.rewind();
  }
  if (tMode == true) {
    dmg=10;
  } else {
    dmg = 3;
  }
  lost = false;
  squareX = new float[4];
  squareY = new float[4];
  alive = true;
  pacX = new int[4];
  pacY = new int[4];
  pacXS = new int[4];
  pacYS = new int[4];
  pacT = new boolean[4];
  penY = int(random(40, height - 40));
  penX = int(random(40, width - 40));
  penYS = 3;
  penXS = 3;
  bossSp = 2.9;
  dmg = 3;
  canUse = true;
  boss = false;
  bossX = -bossS;
  bossY = random(40, height - 40);
  gameTimer = new Timer(3*60);
  abilityTimer = new Timer(10);
  hue = 0;
  pacT[0] = true;
  isTouching = new boolean[4];
  distance = new float[4];
  angle = new float[4];
  won = false;
  replay = false;
  borderHue = 0;
  BGM.rewind();
  BGM.play();
  strokeWeight(5);
  colorMode(HSB, 360, 100, 100);
  hue = 0;
  for (int i = 0; i < pacX.length; i++) {
    pacX[i] = -100;
    pacY[i] = -100;
  }
}
void boarder() {
  if (canUse) {
    strokeWeight(5);
    stroke(random(255), random(255), random(255));

    // Top border
    line(0, 0, displayWidth, 0);

    // Bottom border
    line(0, displayHeight, displayWidth, displayHeight);

    // Left border
    line(0, 0, 0, displayHeight);

    // Right border
    line(displayWidth, 0, displayWidth, displayHeight);
  }
}

// settings visuals
void setting() {
  if (settings) {
    background(0);
    text("Mr. T mode?", width/2, height/2);
    text("press Y for Yes N for No", width/2, height/2+30);
    text("Currently, it is: "+tMode, width/2, height/2+60);
    text("Press E to go to main screen", width/2, height/2+90);
  }
}

// key pressed for intro and settings
void keyPressed() {
  if ((key == 's' || key == 'S') && intro) {
    settings = true;
  }
  if ((key == 'y' || key == 'Y') && settings) {
    tMode = true;
    dmg = 10;
  }
  if ((key == 'n' || key == 'N') && settings) {
    tMode = false;
  }
  if ((key == 'e' || key == 'E') && settings) {
    settings = false;
  }
}

/*

 
 
 4MMMMMMMMMMMML
 4MMMMMMMMMMMMMMMML
 MMMMMMMMMMMMMMMMMMML
 4MMMMMMMMMMMMMMMMMMMMM
 4MMMMMMMMMMMMMMMMMMMMMML
 MMMMP   MMMMMM   MMMMMMM
 MMMM MM  MMM  MM  MMMMMM
 MMMM MM  MMM  MM  MMMMML
 MMM MP,,,,,,,MM  MMMMMM
 MM,"          "MMMMMMP
 MMw           'MMMMMM
 MM"w         w MMMMMMML
 MM" w       w " MMMoMMML
 MMM " wwwwwww "  MMMMMMML
 MMMP   ".,,,,,,"     MMMMMMMML
 MMMP                    MMMMMMMML
 MMMMM                      MMMMMMMML
 MMMMM,,-''             ''-,,MMMMMMMMML
 MMMMM                          MMMMMMMMML
 MMMMM                            MMMMMMMMML
 MMMMM                             MMMMMMMMMM
 MMMM                               MMMMMMMMMM
 MMMMM                               MMMMMMMMMML
 MMMMM                                MMMMMMMMMMM
 MMMMMM                                MMMMMMMMMMM
 MMMMMMM                               MMMMMMMMMMM
 """"MMMM                             MMMMMMMMMMP
 "     ""MMM                            MMMMMMMMP
 "" "         "MMMMMM                      """"MMMMMP"""
 "               "MMMMMMM                   ""   """"""   "
 "                ""MMMMMM                 M"             " ""
 "                 "                   MMM"                  "
 "                   "M               MMMM"                   "
 "                    "MM        MMMMMMMMM"                ""
 "                    "MMMMMMMMMMMMMMMMMMM"              """
 """"                "MMMMMMMMMMMMMMMMMM"           """"
 """"""""       MMMMM               "        ""
 """"""""                      """""""
 
 
 */
