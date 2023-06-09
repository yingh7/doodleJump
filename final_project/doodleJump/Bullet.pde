public class Bullet {
  PVector pos;
  float speedY = -10; // going up is negative
  float speedX = 0;
  int bulletSize = 10;
  Bullet(Player p, float speedX){
    pos = new PVector( p.pos.x + p.playerSize/2, p.pos.y);
    this.speedX = speedX;
  }
  public void drawBullet(){
    fill( #f5426f);
    ellipse( pos.x, pos.y, bulletSize, bulletSize);
    updateBullet();
  }
  public void updateBullet(){
    pos.y += speedY;
    pos.x += speedX;
  }

}
