abstract class screen{
 abstract void update(float dt);
 abstract void draw();
}

public class mainMenu extends screen{
  boolean selected;
  float paddleTilt = radians(90);
  boolean clockwise;
  
  bat screenBat = new bat(true);
  
  public mainMenu(){
   screenBat.x = 150;
   screenBat.y = 40;
  }
  
  public void update(float dt){
    if (mouseY > 100-textAscent() && mouseY < 100+textDescent()){
      textSize(16);
      if (mouseX > 150-textWidth("Start")/2 && mouseX < 150+textWidth("Start")/2){
          selected = true;
          screenBat.x = 150;
           screenBat.y = 100-5;
          if (mousePressed){
            currentScreen = gameInstance;
          }
        } else {
          selected = false;
        }
    } else {
          selected = false;
    } 
    
    if (mouseY > 115-textAscent() && mouseY < 115+textDescent()){
      textSize(16);
      if (mouseX > 150-textWidth("Quit")/2 && mouseX < 150+textWidth("Quit")/2){
          selected = true;
          screenBat.x = 150;
           screenBat.y = 115-5;
          if (mousePressed){
            exit();
          }
        } else {
          selected = false;
        }
    } else {
          selected = false;
    }
    
    if (paddleTilt > radians(-45+90) && paddleTilt < radians(45+90)){
      if (clockwise)
          paddleTilt -= radians(45)*dt;
        else
          paddleTilt += radians(45)*dt;
    } else {
     clockwise = !clockwise; 
     if (clockwise)
          paddleTilt -= radians(45)*dt;
        else
          paddleTilt += radians(45)*dt;
    }
      
    
  }
  
  public void draw(){
    //background(0);
    textSize(32);
    fill(255,255,255);
    textAlign(CENTER);
    text("PONG", 150, 50);
    
    textSize(16);
    text("Start", 150, 100);
    
    textSize(16);
    text("Quit", 150, 115);
    
    //paddle inverts colors REFECTOR at some point
    loadPixels();
    PGraphics stencil = createGraphics(300, 200);
    
    pushMatrix();
    stencil.beginDraw();
    stencil.background(0);
    stencil.translate(screenBat.x, screenBat.y);
    stencil.rotate(paddleTilt);
    //PImage inverted = get(mouseX-30, mouseY-10, 60, 20);
    PImage inverted = createImage(60, 20, RGB);
    inverted.loadPixels();
    for (int i = 0; i < inverted.pixels.length; i++) {
      inverted.pixels[i] = color(255, 255, 255); 
    }
    inverted.updatePixels();
    stencil.translate(-screenBat.x, -screenBat.y);
    //stencil.image(inverted, mouseX-30, mouseY-10);
    stencil.rect(screenBat.x-15/2,screenBat.y-60/2,15,60);
    stencil.endDraw();
    popMatrix();
    
    PImage screenCopy = get();
    screenCopy.mask(stencil);
    screenCopy.filter(INVERT);
    
    image(screenCopy, 0, 0);
  }
}

public class game extends screen{
  ArrayList<gameObject> objects;
  
  public ball newBall;
  bat playerBat, aiBat;
  controller player, ai;
  
  public game(){
    objects = new ArrayList<gameObject>();
    
    newBall = new ball();
    objects.add(newBall);
    
    playerBat = new bat(true);
    objects.add(playerBat);
    
    aiBat = new bat(false);
    objects.add(aiBat);
    
    player = new playerController(playerBat);
    objects.add(player);
    
    ai = new aiController(aiBat, newBall);
    objects.add(ai);
  }
  
  public void update(float dt){
    //game logic
    for (int i = 0; i < objects.size(); i++) {
      objects.get(i).update(dt);
    }
    if (playerBat.collision(newBall) || aiBat.collision(newBall)){
     newBall.velocity.x = -newBall.velocity.x; 
     newBall.speed += 100; 
    }
  }
  
  public void draw(){
    //rendering
    for (int i = 0; i < objects.size(); i++) {
      objects.get(i).draw();
    } 
  }
}