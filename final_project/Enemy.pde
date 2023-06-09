public class Enemy {
  float x,y; // x and y refer to the coordinates of the top left of the enemy
  float len,wid; // length and width of the enemy
  //also another variable specifying type of enemy?

  // constructor
  public Enemy(){
    x = (float) Math.random()*430; // random float from [0, 429]
    y = -50; // generate 50 units above the screen
    len = 50;
    wid = 50;
  }
  
  public void drawEnemy(){
    fill(#9c75ff);
    stroke(0);
    rect(x, y, len, wid);
  }
  
  public boolean isWithin( Player p){
    return p.pos.x >= x && p.pos.x <= x+len && p.pos.y >= y && p.pos.y <= y+wid;
  }
  
  public boolean isWithin( Bullet b){
    return b.pos.x >= x && b.pos.x <= x+len && b.pos.y >= y && b.pos.y <= y+wid;
  }
}
