public class Player {
  PVector pos;
  float speedX = 5;
  float gravity = 0.5;
  float gravitySpeed = 0;
  int playerSize = 25;
  Player(){
    pos = new PVector( 240 - playerSize, 720 -100);
  }
  public void drawPlayer(){
    fill( #93e65c);
    rect( pos.x, pos.y, playerSize, playerSize);
  }
  public void updatePlayer(){
    gravity();
    if( keyPressed ) move();
  }
  private void gravity(){
    if( gravitySpeed < 20){
    gravitySpeed += gravity;
    }
    pos.y += gravitySpeed;
  }
  public void move(){
    //println(keyCode);
    if (keyCode == RIGHT || key == 'd') {
      if( speedX < 0) speedX = 8;
      pos.x += speedX;
      if( pos.x > 480) pos.x = 0;
    }
    else if (keyCode == LEFT || key == 'a'){
      if( speedX > 0) speedX = -8;
      pos.x += speedX;
      if( pos.x < 0) pos.x = 480;
    }
  }
  
}
