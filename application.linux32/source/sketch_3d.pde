//is screen centered? (only once)
boolean cen=false;

//wall of debug text
boolean debugText;

//adjust camera during right click?
boolean adjCam;

//jumping
//zv = velocity on the Z axis
//g = gravity constant
float zv;
float g;

//turn camera down,left,up,right respectively
boolean td=false;
boolean tl=false;
boolean tu=false;
boolean tr=false;

//mouse left/right
boolean ml,mr;

//w,a,s,d,shift,space registry
boolean w,a,s,d,sh,sp;

//player location vector (x,y,z)
PVector loc = new PVector();

//camera pseudo-location (middle of the screen)
float x2;
float y2;
float z2;

//camera rotation
float camRotZ;
float camRotX = 75;

//floor rotation
float frotZ,frotX;

//movement speed
float spd=20;

//grass texture used as floor
PImage grass = new PImage();

void setup(){
  //size of the window, use 3d rendered
  size(1600,900,P3D);
  
  //uncomment if you want to see wall of debug text
  debugText = true;
  
  x2=width/2;
  y2=height/2;
  
  background(0);
  frameRate(30);
  
  //load grass texture & change the way it is rendered
  grass = loadImage("grass.jpg");
  textureWrap(REPEAT);
  textureMode(NORMAL);
  
  g = 3;
}

void draw(){
  //center the screen once at the start of the program
  if(!cen){
    frame.setLocation(displayWidth/2-width/2,displayHeight/2-height/2);
    cen=true;
  }
  
  
  background(0);
  
  //calculate cam and player movement
  moveCam();
  move();
  
  //all the graphics are located here
  textSize(25);
  fill(255);
  pushMatrix();
    translate(x2,y2,z2);
    
    //responsible for rotating everything based on camera rotation
    //creating the illusion of a 3rd person view
    rotateX(radians(camRotX));
    rotateZ(radians(camRotZ));
    pushMatrix();
      //rotate the floor and move it according to player x,y,z
      rotateZ(radians(frotZ));
      //the -150 is the "height" of the player
      translate(0,0,-150);
      translate(loc.x,loc.y,loc.z);
      
      //floor shape
      beginShape();
        texture(grass);
        
        vertex(-10000,-10000,0,0,0);
        vertex(10000,-10000,0,1,0);
        vertex(10000,10000,0,1,1);
        vertex(-10000,10000,0,0,1);
      
      endShape();
    popMatrix();
    pushMatrix();
    
      //player (just a sphere, but can be anything if you put it here)
      shininess(3.0);
      fill(125,125,125);
      stroke(195);
      sphere(25);
      line(0,0,0,-100);
    popMatrix();
  popMatrix();
  fill(255);
  stroke(255);
  
  //calculate X and Y velocity based on rotation angle
  float addX = ((sh) ? spd*cos(radians(frotZ))*4 : spd*cos(radians(frotZ)));
  float addY = ((sh) ? spd*sin(radians(frotZ))*4 : spd*sin(radians(frotZ)));
  
  if(debugText){ text("x: "+loc.x+", y: "+loc.y+", z: "+loc.z+"\n"+"+x: "+addX+", +y: "+addY+"\nshift: "+sh+", space: "+sp+", z2: "+z2+", adjust cam: "+adjCam+"\n"+"frotZ: "+frotZ+", frotX: "+frotX+"\ncamRotZ: "+camRotZ+", camRotX: "+camRotX,20,40); }
  
  textAlign(RIGHT);
  text("Move around with WASD, jump with Spacebar\nTest the movement and see what's possible\n\nRotate camera while holding LMB\nRotate player while holding RMB",width-20,120);
  textAlign(LEFT);
  //change color of buttons at the top right depending on whether they're highlighted or not
  if(mouseX > width-100 && mouseY < 50){
    fill(155);
    rect(width-110,20,90,40);
    fill(255);
    text("RESET",width-100,50);
  } else {
    fill(80);
    rect(width-110,20,90,40);
    fill(255);
    text("RESET",width-100,50);
  }
  
  if(adjCam){
    fill(125);
    rect(width-310,20,175,40);
    fill(255);
    text("ADJUST CAM",width-300,50);
  } else {
    fill(80);
    rect(width-310,20,175,40);
    fill(255);
    text("ADJUST CAM",width-300,50);
  }
}

//register mouse clicks
void mousePressed(){
  if(mouseButton == LEFT){
    noCursor();
    ml=true;
  } else if(mouseButton == RIGHT){
    noCursor();
    mr=true;
  }
  
  //reset button
  if(mouseX > width-110 && mouseX<width-20 && mouseY < 60){
    camRotZ=0;
    camRotX=75;
    frotZ=0;
    frotX=0;
    
    loc.set(0,0,0);
  } 
  
  //adjust cam button
  if(mouseX > width-310 && mouseX<width-135 && mouseY < 60){
    if(adjCam){
      adjCam = false;
    } else {
      adjCam = true;
    }
  }
}

//mouse wheel for zooming in
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(z2+10<650){
    if(e != 0) {
      if(e < 0) {
        z2+=10;
      } 
    }
  } 
  if(e != 0) {
    if(e > 0) {
      z2-=10;
    }
  }
}

//registering key presses here, i'm using an extremely inefficient system, a better one
//is using an array of boolean variables, storing each keycode like so:
//
//boolean[] pressed = new boolean[256]
//
//on key press:
//pressed[keyCode] = true;
//
//on key release:
//pressed[keyCode] = false;
//
//then in your code you just do
//if(pressed[UP]) { do something; }

void keyPressed(){
  if(key == 'a' || key == 'A'){
    a=true;
  } if(key == 'd' || key == 'D'){
    d=true;
  } else if(key == 'w' || key == 'W'){
    w=true;
  } if(key == 's' || key == 'S'){
    s=true;
  } 
  if(key == CODED && keyCode == 16){ sh=true; }
  if(key == ' '){ 
    //sp = false;
    //if space is pressed, set the Z velocity to -35 (player jumps up)
    zv=-35;
  }
}

//continuation of the key register system
void keyReleased(){
  if(key == 'a' || key == 'A'){
    a=false;
  } else if(key == 'd' || key == 'D'){
    d=false;
  } else if(key == 'w' || key == 'W'){
    w=false;
  } else if(key == 's' || key == 'S'){
    s=false;
  } 
  if(key == CODED && keyCode == 16){ sh = false; }
}

//check which direction the mouse is moving while it is being dragged
void mouseDragged(){
  if(pmouseX>mouseX){
    tl=false;
    tr=true;
  } if(pmouseX<mouseX){
    tr=false;
    tl=true;
  } if(pmouseY>mouseY){
    tu=true;
    td=false;
  } if(pmouseY<mouseY){
    td=true;
    tu=false;
  }
}

//when the mouse is released, change all variables regarding it
//to false, and restore the cursor
void mouseReleased(){
  tr=false;
  tl=false;
  tu=false;
  td=false;
  ml=false;
  mr=false;
  if(mouseButton == RIGHT || mouseButton == LEFT){
    cursor();
  }
}

//camera calculation
void moveCam(){
  //if mouse left is pressed
  if(ml){
    
    //cam Z
    //if dragging the mouse left
    if(tl){
      if(camRotZ-((mouseX-pmouseX)/2)<0) { camRotZ+=360; }
      camRotZ+=(pmouseX-mouseX)/2;
    } 
    //if dragging the mouse right
    else if(tr) {
      if(camRotZ+((pmouseX-mouseX)/2)>360) { camRotZ-=360; }
      camRotZ-=(mouseX-pmouseX)/2;
    }
    
    //cam X
    //if dragging the mouse down
    if(td && camRotX > 0){
      camRotX+=(pmouseY-mouseY)/2;
    } 
    //if dragging the mouse up
    else if(tu && camRotX < 95){
      camRotX-=(mouseY-pmouseY)/2;
    }
  } 
  //if mouse right is pressed
  else if(mr){
    
    //if right click is held, change the floor rotation on the Z axis
    //instead of changing the camera rotation on the Z axis
    //so you can turn the character with right click instead of
    //with the A and D keys
    
    //dragging left
    if(tl){
      if(frotZ-((mouseX-pmouseX)/2)<0) { frotZ+=360; }
      frotZ+=(pmouseX-mouseX)/2;
    } 
    //dragging right
    else if(tr) {
      if(frotZ+((pmouseX-mouseX)/2)>360) { frotZ-=360; }
      frotZ-=(mouseX-pmouseX)/2;
    }
    
    //if adjust cam is enabled, while holding right click,
    //increment/decrement the camera rotation until it is 0°
    //to center the cam during right click
    if(adjCam){
      if(camRotZ+1<=360 && camRotZ>180){
        camRotZ+=1;
      } else if(camRotZ-1>=0 && camRotZ<=180) {
        camRotZ-=1;
      }
    }
    
    //cam X
    //same thing as with the left mouse button
    if(td && camRotX > 0){
      camRotX+=(pmouseY-mouseY)/2;
    } else if(tu && camRotX < 95){
      camRotX-=(mouseY-pmouseY)/2;
    }
  }
}

//function containing everything required to move the player
void move(){
  
  //these two variables are for determining the speed at which the player should move
  //in the two X and Y directions, relative to the angle, in order to create
  //the illusion that he is able to travel in any direction
  //
  //the base of this calculation is 
  //velocity x = spd*sin(radians(angle));
  //velocity y = spd*cos(radians(angle));
  //then simply adding/substracting these two values from the X and Y values, respectively
  //will create the desired effect
  float velX = (sh) ? spd*sin(radians(frotZ))*4 : spd*sin(radians(frotZ));
  float velY = (sh) ? spd*cos(radians(frotZ))*4 : spd*cos(radians(frotZ));
  
  //this creates the jumping effect, you can adjust how high you jump and how fast you fall by
  //changing the zv and g values at the beginning of the code
  if(loc.z+zv+g < 0+g){
    zv+=g;
    loc.z+=zv;
  } else {
    zv = 0;
    loc.z = 0;
  }
  
  //if moving forward
  if(w){
    //and also holding right click and the A button
    //making it look like you're travelling to the top left corner of your character
    //instead of straight forward and turning at the same time
    //
    //all this requires is a simple addition of 45° to both the X and Y values
    if(a && mr){
      loc.add((sh) ? spd*sin(radians(frotZ+45))*4 : spd*sin(radians(frotZ+45)),(sh) ? spd*cos(radians(frotZ+45))*4 : spd*cos(radians(frotZ+45)),0.0);
    } 
    //and also holding right click and the D button
    else if(d && mr){
      loc.add((sh) ? spd*sin(radians(frotZ-45))*4 : spd*sin(radians(frotZ-45)),(sh) ? spd*cos(radians(frotZ-45))*4 : spd*cos(radians(frotZ-45)),0.0);
    } 
    //if only moving forward
    else {
      loc.add(velX, velY, 0.0);
    }
  } 
  //if moving backward
  else if(s){
    //and also holding right click and the A button
    if(a && mr){
      loc.sub((sh) ? spd*sin(radians(frotZ-45))*4 : spd*sin(radians(frotZ-45)),(sh) ? spd*cos(radians(frotZ-45))*4 : spd*cos(radians(frotZ-45)),0.0);
    } 
    //and also holding right click and the D button
    else if(d && mr){
      loc.sub((sh) ? spd*sin(radians(frotZ+45))*4 : spd*sin(radians(frotZ+45)),(sh) ? spd*cos(radians(frotZ+45))*4 : spd*cos(radians(frotZ+45)),0.0);
    } 
    //if only moving backwards
    else {
      loc.sub(velX, velY, 0.0);
    }
  } 
  //else, if not moving forward or backward
  else if(!w && !s){
    //but you are holding right click and A
    if(a && mr){
      //add 90° to the angle and calculate X and Y velocity
      loc.add((sh) ? spd*sin(radians(frotZ+90))*2 : spd*sin(radians(frotZ+90))/2,(sh) ? spd*cos(radians(frotZ+90))*2 : spd*cos(radians(frotZ+90))/2,0.0);
    } 
    //or you are holding right click and D
    else if(d && mr) {
      loc.add((sh) ? spd*sin(radians(frotZ-90))*2 : spd*sin(radians(frotZ-90))/2,(sh) ? spd*cos(radians(frotZ-90))*2 : spd*cos(radians(frotZ-90))/2,0.0);
    }
  } 
  
  //if you are not moving forward, backward, or holding right click
  //but you are holding A or D alone,
  //you will only turn left/right
  //you can hold left click during this time to adjust the camera
  if(a && mr != true){
    if(frotZ+1>360){
      frotZ=0;
    }
    frotZ+=3.5;
  }
  if(d && mr != true){
    if(frotZ-1<0){
      frotZ=360;
    }
    frotZ-=3.5;
  } 
}