/****************************************   
*          Amazing tattoo app!          *          
*          MADE BY JOS BOOTSMA          *
*          Creative Multimedia          *
*****************************************/

// -------------------------------- Import libraries, 
// -------------------------------- download them if you have to (SKETCH > IMPORT LIBRARY)
import gab.opencv.*;
import processing.video.*;
import processing.sound.*;
import java.awt.Robot;
import java.awt.*;
import java.awt.image.*;
// -------------------------------- Declare pictures and sounds
PImage tattoo;
PImage picture;
PImage pt; //picture with added tattoo
PImage screenshot;
SoundFile sound;
boolean soundPlayed; //false by default
// -------------------------------- Declare capture(video) object and openCV
Capture video;
OpenCV opencv;
// -------------------------------- Declare ints for Tattoo dimensions
int roiWidth = 150;
int roiHeight = 150;
int xpos, ypos;
//boolean useROI = true;

void setup() { // ---------------------------------------------------------- Setup
  tattoo = loadImage("facetattoo.png");
  
  video = new Capture(this, 640,480);                    //set up video
  opencv = new OpenCV(this, video.width, video.height);  //set up opencv
  printArray(Capture.list());                            //see webcam settings
        
  size(640, 480);                                        //set up window size
  video.start();
  
  sound = new SoundFile(this, "morph.wav");
} // ----------------------------------------------------------------------- End of setup()

void draw() { // ----------------------------------------------------------- draw
  
  /*/////       optional Region of Interest code     ///////
  if (useROI) {
    opencv.setROI(mouseX, mouseY, roiWidth, roiHeight);
  }
  // show ROI box
  = opencv.findCannyEdges(20,75);    
  
  = prevent ROI from stopping after dragging out window
  /*xpos = mouseX + roiWidth;
  ypos = mouseY + roiHeight; 
    if(xpos > video.width || ypos > video.height){
  if (roiHeight > 10 && roiWidth > 10) 
    opencv.setROI(mouseX, mouseY, (roiWidth -= 10), (roiHeight -=10));
  }
  image(opencv.getOutput(), 0, 0)
  //////////////////////////////////////////////////////////*/

  if (video.available()) {
    video.read();                       // check for video
  } 
  opencv.loadImage(video);
  image(video,0,0);                     // display video
    
  // tattoo image to follow mouse
  image(tattoo, mouseX, mouseY);        // display tattoo following the mouse
  tattoo.resize(roiWidth, roiHeight);   // resize tattoo according to keystrokes
  
  // menu bar
  fill(#009bc8, 150);
  rect(0,0, 640, 70);
  noStroke();
  
  // text
  String s = "←↑→↓ = Scale tattoo, Mouseclick = Take Picture, Space = Restart video\n Press 0-9 for different tattoos. Your picture will be saved in the data folder";     
  textSize(15);
  fill(255);                            //text fill color
  text(s, 10, 10, 640, 60);             //string, x1, y1, x2, y2
} // ----------------------------------------------------------------------- End of draw()

void captureEvent(Capture video){
  video.read();
} // ----------------------------------------------------------------------- captureEvent


void mouseClicked() // ----------------------------------------------------- mouseClicked          
{
  if (soundPlayed == false){           // check to stop from spamming sound
  sound.play();
  soundPlayed = true;
  }
  //take picture
  image(video, 0, 0);
  tint(255, 175);  // change opacity
  image(tattoo, mouseX, mouseY);

  saveFrame("data/screenshot####.jpg"); // #### = framerate, giving each picture a unique nummer
  delay(300);
  video.stop();
  
  tattoo = loadImage("white.png");     // load empty image into tattoo to hide it
} // ----------------------------------------------------------------------- end of mouseClicked

void keyPressed() { // ----------------------------------------------------- keyPressed
    if (key == ' '){                   // ' ' stands for space
      // restart video
    video.start();
      // reload tattoo image
      tattoo = loadImage("facetattoo.png");
    }
    if (key == '1') {
      tattoo = loadImage("facetattoo.png");
    }
    if (key == '2') {
      tattoo = loadImage("tattoo.png");
    }
    if (key == '3') {
      tattoo = loadImage("tattoo3.png");
    }
    if (key == '4') {
      tattoo = loadImage("tattoo4.png");
    }
    if (key == '5') {
      tattoo = loadImage("tattoo5.png");
    }
    if (key == '6') {
      tattoo = loadImage("tattoo6.png");
    }
    if (key == '7') {
      tattoo = loadImage("tattoo7.png");
    }
    if (key == '8') {
      tattoo = loadImage("tattoo8.png");
    }
    if (key == '9') {
      tattoo = loadImage("tattoo9.png");
    }
    if (key == '0') {
      tattoo = loadImage("tattoo0.png");
    }
      if (key == CODED) {  //check for special keys (like arrow keys)
    if (keyCode == RIGHT) {    // adjust ROI(tattoo) with arrow keys
      if (roiWidth < 400)  
      roiWidth += 10;
    } if (keyCode == LEFT) {
      if (roiWidth > 10)
      roiWidth -= 10;
    } 
    if (keyCode == UP) {
      if (roiHeight > 10)
      roiHeight -= 10;
    }
    if (keyCode == DOWN) {
      if (roiHeight < 600)
      roiHeight += 10;
    }
   }
} // ----------------------------------------------------------------------- end of keyPressed