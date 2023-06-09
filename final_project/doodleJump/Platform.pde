public class Platform {
  float x,y; // x and y refer to the coordinates of the top left of the platform
  float len,wid; // length and width of the platform
  int type = 0; // 0 standard, 1 breakable, 2 moving, 3 fake
  int increment = 3;
  boolean generateSpring = false; //turns false after generating a spring
  Spring s; 
  //also another variable specifying type of platform

  // constructor
  // standard platform
  public Platform(float x, float y){
    this.x = x;
    this.y = y;
    len = 90;
    wid = 20;
    if ((int) (Math.random() * 5) == 0)
      generateSpring = true;
  }
  
  // other platforms
  public Platform(float x, float y, int type){
    this.x = x;
    this.y = y;
    this.type = type;
    len = 90;
    wid = 20;
    if ((int) (Math.random() * 5) == 0 && type != 3)
      generateSpring = true;
  }
  
  public void drawPlatform(){
  if( type == 0) fill(#75fa5a);
  else if( type == 1) fill(#f2f5f3);
  else if( type == 2) fill(#00FFFF);
  else if( type == 3) fill(#6e5c56);
    stroke(0);
    rect(x, y, len, wid);
  }
  
  public void movePlatform(){
    if (type == 2){
      if( x > 480-len && increment>0 || x < 0 && increment<0)
        increment = -increment;
      x += increment;
      if (s != null) s.x += increment;
    }
  }
  
  public void createSpring(){
    if (generateSpring) {
      s = new Spring(this);
      generateSpring = false;
    }
  }
  
  public void drawSpring(){
    if (s != null) {
      s.drawSpring();
    }
  }
  
  public boolean isWithinX( float playerX){
    return playerX >= x && playerX <= x+len;
  }
  public boolean passesTop( float ini, float fin){
    return ini <= y && fin+10 >= y;
  }
  public void disappear(){
    if( type == 1 || type == 3) y = 1000;
  }
}
  
