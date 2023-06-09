public class Spring {
  float x,y; // x and y refer to the coordinates of the top left of the platform
  float len = 15;

  // constructor
  public Spring(Platform p){
    x = p.x + (float) Math.random() * (p.len - len); // -len to avoid generating over the right edge
    y = p.y - len; // -len so the spring generates on top of the platform
  }
  
  public void drawSpring(){
    fill(#748587);
    stroke(0);
    rect(x, y, len, len);
  }
  
  public boolean isWithin( Player p){
    return p.pos.x+p.playerSize >= x && p.pos.x <= x+len &&
           p.pos.y+p.playerSize+p.gravitySpeed >= y && p.pos.y <= y+len;
  }
}
