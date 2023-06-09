public class Enemy {
  float x,y; // x and y refer to the coordinates of the top left of the enemy
  float len,wid; // length and width of the enemy
  int type; // 0 standard, 1 moving
  int increment;

  // constructor
  public Enemy(){
    x = (float) (Math.random()*430); // random float from [0, 429]
    y = -50; // generate 50 units above the screen
    len = 40;
    wid = 40;
    type = (int) (Math.random()*2); // random int 0 or 1
    if (type == 1) increment = 3;
  }
  
  public void drawEnemy(){
    fill(#9c75ff);
    stroke(0);
    rect(x, y, len, wid);
  }
  
  public void moveEnemy(){
    if (type == 1){
      if( x > 480-len && increment>0 || x < 0 && increment < 0)
        increment = -increment;
      x += increment;
    }
  }
  
  public boolean isWithin( Player p){
    return p.pos.x+p.playerSize >= x && p.pos.x <= x+len &&
           p.pos.y+p.playerSize >= y && p.pos.y <= y+wid;
  }
  
  public boolean isWithin( Bullet b){
    return b.pos.x >= x && b.pos.x <= x+len && b.pos.y >= y && b.pos.y <= y+wid;
  }
}
