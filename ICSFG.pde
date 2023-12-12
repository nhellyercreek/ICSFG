boolean alive;
int[] pacX;
int[] pacY;
int penY;
int penX;
int penYS;
int penXS;
int[] pacXS;
int[] pacYS;
Timer gameTimer;
Timer abilityTimer;
boolean canUse;
int dam;
float hue;
boolean won;

void setup() {
  fullScreen();
  frameRate(120);
  
  alive = true;
  pacX = new int[4];
  pacY = new int[4];
  pacXS = new int[4];
  pacYS = new int[4];
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
  won = false;
}

void draw() {
  backgroundC();
  logic();
  drawPen();
  visuals();
  pac();

  if (gameTimer.isFinished()) {
    won = true;
    
  }

  if (keyPressed) {
    handleKeyPress();
  }
}

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

void pac() {
  
}

void visuals() {
  textSize(15);
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
    won = true;
  }
}

void backgroundC() {
  hue += 0.1;
  if (hue > 360) {
    hue = 0;
  }
  background(hue, 80, 50);
}

void drawPen() {
  fill(255);
  ellipse(penX, penY, 25, 25);
}
