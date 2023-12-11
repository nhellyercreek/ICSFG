//Final game Aryan & Noah
boolean alive;
int [] pacX;
int [] pacY;
int penX;
int penY;
int penXS;
int penYS;
int [] pacXS;
int [] pacYS;
int timer;
boolean canUse;
int dam;

void setup() {
  fullScreen();
  alive = true;
  pacX = new int [4];
  pacY = new int [4];
  pacXS = new int [4];
  pacYS = new int [4];
  penX = int(random(0,width-20));
  penY =int(random(0,height-20));
  penXS = 3;
  penYS = 3;
  dam = 3;
  canUse = true;
  timer = 120000;
}
