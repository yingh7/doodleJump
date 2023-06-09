static final int SQUARE_SIZE = 16; // size of each square on the grid
static final int w = 30;
static final int h = 45; // how many squares can be allocated
int maxPlatforms = 20;
int curPlatforms = 1;
int numEnemies = 0;
int difficulty; // higher is harder
int score;
ArrayList<Platform> platforms = new ArrayList<Platform>( maxPlatforms);
Player jumper = new Player();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
int enemySpawnThreshold = 500; //threshold to pass to spawn next enemy

void setup() {
  score = 0;
  difficulty = 1;
  size(480, 720);
  grid();
  platforms.add(new Platform(width/2-50, height-25)); //starting platform
  //enemies.add(new Enemy(240, 5)); //starting enemy
}

void draw() {
  grid();
  updatePlatforms();
  addPlatform();
  jumper.updatePlayer();
  jumper.drawPlayer();
  checkCollision();
  checkBullets();
  addEnemy();
  drawEnemies();
  scroll();
  score();
  gameOver();
}

void grid() {
  fill(#FFF7F0);
  stroke(#FCDDBD);
  for(int i=0; i < w; i++){
    for(int j=0; j < h; j++)
     rect(i*SQUARE_SIZE, j*SQUARE_SIZE,SQUARE_SIZE, SQUARE_SIZE);
  }
}

void updatePlatforms() {
  for(Platform p : platforms){
    p.drawPlatform();
    p.movePlatform();
  }
}

void addPlatform(){
  Platform latest = platforms.get( curPlatforms -1);
  if (platforms.size() < maxPlatforms){
    if((Math.random() * 10) <= 1) platforms.add( new Platform(  (float)Math.random() * (480-platforms.get(0).len), latest.y -(float)Math.random()*(100+difficulty*5), 2 ));
    else platforms.add( new Platform(  (float)Math.random() * (480-platforms.get(0).len), latest.y -(float)Math.random()*(100+difficulty*5) ));
    curPlatforms++;
  }
}
void scroll(){
  if ( jumper.gravitySpeed < 0 && jumper.pos.y <= 360){
    for( int i = 0; i < curPlatforms; i++){
      Platform temp = platforms.get(i);
      temp.y -= jumper.gravitySpeed;
      if( temp.y > 720){
         platforms.remove(i);
         i--;
         curPlatforms--;
      }
    }
    for(int i=0; i < numEnemies; i++){
      Enemy temp = enemies.get(i);
      temp.y -= jumper.gravitySpeed;
      if (temp.y > 720){
        enemies.remove(i);
        i--;
        numEnemies--;
      }
    }
    score -= jumper.gravitySpeed;
    jumper.pos.y -= jumper.gravitySpeed;
  }
}

void checkCollision(){
  float xRight = jumper.pos.x + jumper.playerSize;
  float xLeft = jumper.pos.x;
  float y = jumper.pos.y + jumper.playerSize;
  
  for( Platform cur: platforms){
    if (jumper.gravitySpeed > 0 && 
        (cur.isWithinX(xRight) || cur.isWithinX(xLeft))){
        if( cur.passesTop(y, y+ jumper.gravitySpeed)){
          jumper.pos.y = cur.y - jumper.playerSize;
          jumper.gravitySpeed = -15;
        } 
    }
  } 
}

void gameOver(){
  if( jumper.pos.y > height) reset();
  for(int i=0 ; i < enemies.size() ; i++){
    if (enemies.get(i).isWithin(jumper)) reset();
  }
}

void reset(){
  jumper = new Player();
  platforms.clear();
  enemies.clear();
  bullets.clear();
  curPlatforms = 1;
  numEnemies = 0;
  enemySpawnThreshold = 500;
  setup();
}

//adds a bullet
void mousePressed() {
  if (mouseX < width/3) {
    bullets.add(new Bullet(jumper, -5));
  } else if (mouseX > 2*width/3) {
    bullets.add(new Bullet(jumper, 5));
  } else {
    bullets.add(new Bullet(jumper, 0));
  }
}

void checkBullets(){
  for(int i=0; i < bullets.size(); i++) {
    bullets.get(i).drawBullet();
    
    //check collision with enemies
    for (int j=0; j < enemies.size(); j++){
      if (enemies.get(j).isWithin(bullets.get(i))){
        enemies.remove(j);
        //bullets.remove(i); //without this line, bullets pierce thru enemies
        numEnemies--;
      }
    }
    //check if go offscreen
    if (bullets.get(i).pos.y <= 0 
    || bullets.get(i).pos.x < 0 
    || bullets.get(i).pos.x > width) 
      bullets.remove(i);
  }
}

void addEnemy(){
  if(score > enemySpawnThreshold){
    enemies.add(new Enemy());
    enemySpawnThreshold += 500; //temp
    numEnemies++;
  }
}

void drawEnemies(){
  for(Enemy e: enemies)
    e.drawEnemy();
}

void score(){
  if ( difficulty <= 30) difficulty = score / 800;
  fill(#000000);
  textSize( 20);
  text( score, 400, 20);
}
