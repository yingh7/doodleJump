public class Platform {
  float x,y; // x and y refer to the coordinates of the top left of the platform
  float len,wid; // length and width of the platform
  int type = 0; // 0 standard, 1 breakable, 2 moving
  int increment = 4;
  //also another variable specifying type of platform

  // constructor
  // standard platform
  public Platform(float x, float y){
    this.x = x;
    this.y = y;
    len = 90;
    wid = 20;
  }
  
  // other platforms
  public Platform(float x, float y, int type){
    this.x = x;
    this.y = y;
    this.type = type;
    len = 90;
    wid = 20;
  }
  
  public void drawPlatform(){
  if( type == 0) fill(#75fa5a);
  else if( type == 2) fill(#00FFFF);
    stroke(0);
    rect(x, y, len, wid);
  }
  public void movePlatform(){
    if (type == 2){
      if( x > 480-len && increment>0) increment = -increment;
      if( x < 0 && increment<0) increment = -increment;
      x += increment;
    }
  }
  
  public boolean isWithinX( float playerX){
    return playerX >= x && playerX <= x+len;
  }
  public boolean passesTop( float ini, float fin){
    return ini <= y && fin+10 >= y;
  }
}
