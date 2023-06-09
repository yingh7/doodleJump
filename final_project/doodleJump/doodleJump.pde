static final int SQUARE_SIZE = 16; // size of each square on the grid
static final int w = 30;
static final int h = 45; // how many squares can be allocated
int maxPlatforms = 20;
int curPlatforms = 1;
int numEnemies = 0;
int difficulty; // higher is harder
int score;
int highScore = 0;
ArrayList<Platform> platforms = new ArrayList<Platform>( maxPlatforms);
Player jumper = new Player();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
int enemySpawnThreshold = 500; //threshold to pass to spawn next enemy
boolean start = true;

public void setup() {
  score = 0;
  difficulty = 1;
  size(480, 720);
  grid();
  platforms.add(new Platform(width/2-50, height-25)); //starting platform
  mainMenu();
}

public void draw() {
  if (start) {
    noLoop();
    mainMenu();
  } else {
    grid();
    updatePlatforms();
    addPlatform();
    jumper.updatePlayer();
    jumper.drawPlayer();
    checkCollision();
    checkBullets();
    addEnemy();
    updateEnemies();
    scroll();
    score();
    gameOver();
  }
}

private void mainMenu(){
  fill(#000000);
  textSize( 30);
  textAlign(CENTER, CENTER);
  text( "Press spacebar or", width/2, height/2 - 15);
  text("click anywhere to start!", width/2, height/2 +15);
  if (highScore != 0) text("Last Highscore: " + highScore, width/2, height/2 + 50);
}

private void grid() {
  fill(#FFF7F0);
  stroke(#FCDDBD);
  for(int i=0; i < w; i++){
    for(int j=0; j < h; j++)
     rect(i*SQUARE_SIZE, j*SQUARE_SIZE,SQUARE_SIZE, SQUARE_SIZE);
  }
}

private void updatePlatforms() {
  for(Platform p : platforms){
    p.drawPlatform(); 
    p.createSpring();
    p.drawSpring();
    p.movePlatform();
  }
}

private void addPlatform(){
  Platform latest = platforms.get( curPlatforms -1);
  if (platforms.size() < maxPlatforms){
    int tempType = 0;
    double rand = Math.random()*100;
    if( rand <= 100 - 7*difficulty) tempType = 0;
    else if( rand <= 75 ) tempType = 1;
    else if( rand <= 90) tempType = 2;
    else tempType = 3;
    if (tempType == 3){
      platforms.add( new Platform( (float)Math.random() * (480-platforms.get(0).len), 
                                 latest.y -((float)Math.random()*(100+difficulty*8)+platforms.get(0).wid),
                                 tempType));
      platforms.add( new Platform( (float)Math.random() * (480-platforms.get(0).len), 
                                 latest.y -((float)Math.random()*(100+difficulty*8)+platforms.get(0).wid),
                                 0));
      curPlatforms++;
    }
    else{
    platforms.add( new Platform( (float)Math.random() * (480-platforms.get(0).len), 
                                 latest.y -((float)Math.random()*(100+difficulty*8)+platforms.get(0).wid),
                                 tempType));
    }
    curPlatforms++;
  }
}

private void scroll(){
  if ( jumper.gravitySpeed < 0 && jumper.pos.y <= 360){
    for( int i = 0; i < curPlatforms; i++){
      Platform temp = platforms.get(i);
      temp.y -= jumper.gravitySpeed;
      if (temp.s != null) temp.s.y -= jumper.gravitySpeed;
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

private void checkCollision(){
  float xRight = jumper.pos.x + jumper.playerSize;
  float xLeft = jumper.pos.x;
  float y = jumper.pos.y + jumper.playerSize;
  
  for( Platform cur: platforms){
    if (jumper.gravitySpeed > 0 && 
        (cur.isWithinX(xRight) || cur.isWithinX(xLeft))){
          if( cur.s != null){
            if( cur.s.isWithin(jumper)) {
              jumper.gravitySpeed = -22;
              cur.disappear();
            }
          }
        if( cur.passesTop(y, y+ jumper.gravitySpeed)){
          if( cur.type == 3) cur.disappear();
          else{
          jumper.pos.y = cur.y - jumper.playerSize;
          jumper.gravitySpeed = -15;
          cur.disappear(); // only disappears if platform type = 1 or 3
          }
        }
    }
  }
}

private void gameOver(){
  if( jumper.pos.y > height) {
    reset();
    noLoop();
    start = true;
  }
  for(int i=0 ; i < enemies.size() ; i++){
    if (enemies.get(i).isWithin(jumper)) {
      reset();
      noLoop();
      start = true;
    }
  }
}

private void reset(){
  jumper = new Player();
  platforms.clear();
  enemies.clear();
  bullets.clear();
  curPlatforms = 1;
  numEnemies = 0;
  enemySpawnThreshold = 500;
  if ( score > highScore) highScore = score;
  setup();
}

//adds a bullet
public void mousePressed() {
  if (start) {
    start = false;
    loop();
  } else {
    if (mouseX < width/3) {
      bullets.add(new Bullet(jumper, -5));
    } else if (mouseX > 2*width/3) {
      bullets.add(new Bullet(jumper, 5));
    } else {
      bullets.add(new Bullet(jumper, 0));
    }
  }
}

public void keyPressed(){
  if (start && key == ' ') {
    start = false;
    loop();
  }
}

private void checkBullets(){
  for(int i=0; i < bullets.size(); i++) {
    bullets.get(i).drawBullet();
    
    //check collision with enemies
    for (int j=0; j < enemies.size(); j++){
      if (enemies.get(j).isWithin(bullets.get(i))){
        enemies.remove(j);
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

private void addEnemy(){
  if(score > enemySpawnThreshold){
    enemies.add(new Enemy());
    enemySpawnThreshold += 750 + Math.random() * 1000;
    numEnemies++;
  }
}

private void updateEnemies(){
  for(Enemy e: enemies) {
    e.drawEnemy();
    e.moveEnemy();
  }
}

private void score(){
  if ( difficulty <= 10) difficulty = score / 1000;
  maxPlatforms = 20 - difficulty;
  fill(#000000);
  textSize( 20);
  textAlign(TOP);
  text( "Score:    " + score, 360, 20);
  text( "High Score:    " + highScore, 317, 40);
}
