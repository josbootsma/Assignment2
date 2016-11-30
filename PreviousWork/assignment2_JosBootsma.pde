/****************************************   
*          MADE BY JOS BOOTSMA          *
*          Creative Multimedia          *
*****************************************/

// -------------------------------- Import libraries
import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

// -------------------------------- Declare video, open cv, source image and arrays
Capture video;
OpenCV opencv;
PImage src;
ArrayList<Contour> contours;

// -------------------------------- ROI
int roiWidth, roiHeight;
int rXL[], rYL[], rW[], rH[];

// <1> Set the range of Hue values for our filter
// ArrayList<Integer> colors;
int maxColors = 4;
int[] hues;
int[] colors;
int rangeWidth = 10;

PImage[] outputs;
int colorToChange = -1;

void setup() { // ---------------------------------------------------------- Setup
  video = new Capture(this, 640, 480);                   //set up video
  opencv = new OpenCV(this, video.width, video.height);  //set up opencv
  contours = new ArrayList<Contour>();
  printArray(Capture.list());                            //see webcam settings
  size(830, 480, P2D);                              //P2D (Processing 2D): 2D graphics renderer that 
                                                    //makes use of OpenGL-compatible graphics hardware.
  
  // Arrays for detection of colors
  colors = new int[maxColors];
  hues = new int[maxColors];
  
  outputs = new PImage[maxColors];
  
  video.start(); 
} // ----------------------------------------------------------------------- End of setup()

void draw() { // ----------------------------------------------------------- draw
  
  background(150); //background color (greyish)
  
  // check for video
  if (video.available()) {
    video.read();
  }

  // <2> Load the new frame of the movie into OpenCV
  opencv.loadImage(video);
  
  // Tell OpenCV to use color information
  opencv.useColor();
  src = opencv.getSnapshot();
  
  // <3> Tell OpenCV to work in HSV color space.
  opencv.useColor(HSB);
  
  detectColors();  //detectColors method gets called
  
  // Show images
  image(src, 0, 0);    //original video image
  for (int i=0; i<outputs.length; i++) {
    if (outputs[i] != null) {
      image(outputs[i], width-src.width/4, i*src.height/4, src.width/4, src.height/4);
      noStroke();
      fill(colors[i]);
      rect(src.width, i*src.height/4, 30, src.height/4);
    }
  }
  
  // Print text if new color expected
  textSize(20);
  stroke(255);
  fill(255);
  
  if (colorToChange > -1) {
    text("click to change color " + colorToChange, 10, 25);
  } else {
    text("press key [1-4] to select color", 10, 25);
  }
  
} // ----------------------------------------------------------------------- End of draw()

//////////////////////
// Detect Functions
//////////////////////

void detectColors() {
    
  for (int i=0; i<hues.length; i++) {
    
    if (hues[i] <= 0) continue;
    
    opencv.loadImage(src);
    opencv.useColor(HSB);
    
    // <4> Copy the Hue channel of our image into 
    //     the gray channel, which we process
    opencv.setGray(opencv.getH().clone());
    
    int hueToDetect = hues[i];
    //    println("index " + i + " - hue to detect: " + hueToDetect);
    
    // <5> Filter the image based on the range of 
    //     hue values that match the object we want to track
    opencv.inRange(hueToDetect-rangeWidth/2, hueToDetect+rangeWidth/2);
    
    //morphology operators
    //opencv.dilate();    //not used
    opencv.erode();

    // 6) Get screenshot for later use
    outputs[i] = opencv.getSnapshot();
  }
  
  // 7) Find contours in our range image.
  //     Passing 'true' sorts them by descending area.
  if (outputs[0] != null) {
    opencv.loadImage(outputs[0]);
    contours = opencv.findContours(true,true);
  }
}


//////////////////////
// Keyboard / Mouse
//////////////////////

void mousePressed() {
  if (colorToChange > -1) {
    
    color c = get(mouseX, mouseY);
    println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
   
    int hue = int(map(hue(c), 0, 255, 0, 180));    //hue to be used for color detection
    
    colors[colorToChange-1] = c;
    hues[colorToChange-1] = hue;
    
    println("color index " + (colorToChange-1) + ", value: " + hue);
  }
}

void keyPressed() {
  
  if (key == '1') {
    colorToChange = 1;
  } else if (key == '2') {
    colorToChange = 2;
  } else if (key == '3') {
    colorToChange = 3;
  } else if (key == '4') {
    colorToChange = 4;
  }
}

void keyReleased() {
  colorToChange = -1; 
}