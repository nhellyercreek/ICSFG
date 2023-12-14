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
int dam;
float hue;
int squareSize = 20;
float [] squareX, squareY;
float speed = 2.5;
boolean [] isTouching;
float [] angle;
float [] distance;
boolean won;
int endTime = 0;
int alpha = 0;
boolean replay = false;
boolean superSpeed;
int countdown = 3000;
int lastChange;
int pacSuper;
String direction;

void setup() {
  fullScreen();
  frameRate(120);
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
  dam = 3;
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
  lastChange = millis();
}

void draw() {
  backgroundC();
  logic();
  drawPen();
  visuals();
  pac();
  pacLogic();
  pacSpeed();

  if (gameTimer.isFinished()) {
    won();
    for (int i = 0; i < pacXS.length; i++) {
      pacXS[i]=0;
      pacYS[i]=0;
    }
  }

  if (keyPressed) {
    handleKeyPress();
  }
}
void pacSpeed() {
  if (lastChange>=countdown) {
    superSpeed=true;
    pacSuper = 10;
  } else {
    superSpeed=false;
    pacSuper = 2;
  }
  if (superSpeed) {
    if (direction =="up") {
      pacX[0]-=pacSuper;
    }else if(direction =="down"){
      pacX[0]+=pacSuper;
    } else if(direction =="left"){
      pacY[0]-=pacSuper;
    } else{
      pacY[0]+=pacSuper;
    }
  }
}

// keypresses
void handleKeyPress() {
  if (key == 'W' || key == 'w') {
    direction = "up";
    penY -= penYS;
  }
  if (key == 'S' || key == 's') {
    penY += penYS;
    direction = "down";
  }
  if (key == 'D' || key == 'd') {
    penX += penXS;
    direction = "right";
  }
  if (key == 'A' || key == 'a') {
    penX -= penXS;
    direction="left";
  }
}

// pacman logic
void pac() {
  for (int i = 0; i < pacX.length; i++) {
    ellipse(pacX[i], pacY[i], 20, 20);
  }

  for (int i = 1; i < pacT.length; i++) {
    if (gameTimer.timeLeft() <= 3 * 60 - 30 * i) {
      pacT[i] = true;
    }
  }
}

void pacLogic() {
  // pacman logic
  float minDistance = squareSize * 2;

  for (int i = 0; i < squareX.length; i++) {

    if (gameTimer.elapsedTime() > i * 30) {
      if (isTouching[i]) {
        dam--;
        squareX[i] = width / 2;
        squareY[i] = width / 2;
      }

      angle[i] = atan2(penY - squareY[i], penX - squareX[i]);
      squareX[i] += cos(angle[i]) * speed;
      squareY[i] += sin(angle[i]) * speed;

      rect(squareX[i] - squareSize / 2, squareY[i] - squareSize / 2, squareSize, squareSize);

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
  // timers
  textSize(15);
  textAlign(CORNER);
  if (canUse) {

    text("Can use ability", 20, 20);
  } else {
    text("Can use ability in: " + abilityTimer.timeLeft() + " Seconds", 20, 20);
    if (abilityTimer.isFinished()) {
      canUse = true;
      abilityTimer.reset();
    }
  }
  text("You'll win in: " + gameTimer.timeLeft() + " Seconds", 20, 40);
}

void logic() {
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
  fill(255);
  ellipse(penX, penY, 25, 25);
}

// win screen
void won() {
  background(0);
  textSize(50);
  textAlign(CENTER);
  text("YOU ESCAPED PACMAN THE PENGUIN HUNTER", width/2, height/2);


  if (!replay) {
    endTime = millis();
    replay = true;
    alpha = 0;
  }
  if (millis() > endTime + 2000) {
    playAgain();
  }
}

// Button Logic
void playAgain() {
  if (alpha < 255) {
    alpha++;
  }

  // Button
  fill(255, alpha);
  rectMode(CENTER);
  rect(width/2, height/2 + 100, 200, 60, 10);

  // Text
  fill(0, alpha);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Play Again", width/2, height/2 + 100);
  won = true;
}
void lose() {
  background(0);
  textSize(50);
  textAlign(CENTER);
  text("RED IS THE COLOR OF DEAD PENGUINS", width/2, height/2);


  if (!replay) {
    endTime = millis();
    replay = true;
    alpha = 0;
  }
  if (millis() > endTime + 2000) {
    playAgain();
  }
  fill(255, alpha);
  rectMode(CENTER);
  rect(width/2, height/2 + 100, 200, 60, 10);

  // Text
  fill(0, alpha);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Play Again", width/2, height/2 + 100);
  won = false;
}

// Button Logic

void mousePressed() {
  // Button pressed
  if (won) {
    if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 && mouseY > height / 2 + 70 && mouseY < height / 2 + 130) {
      resetGame();
    }
  }
}

void resetGame() {
  // Reset game
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
  dam = 3;
  canUse = true;
  gameTimer = new Timer(3*60);
  abilityTimer = new Timer(10);
  hue = 0;
  pacT[0] = true;
  isTouching = new boolean[4];
  distance = new float[4];
  angle = new float[4];
  won = false;
  replay = false;
  endTime = 0;
  alpha = 0;
}
