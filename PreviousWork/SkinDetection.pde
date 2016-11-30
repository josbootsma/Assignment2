/****************************************   
*          MADE BY JOS BOOTSMA          *
*          Creative Multimedia          *
*****************************************/

//libraries
import gab.opencv.*;                         //import openCV
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.imgproc.Imgproc;           
import processing.video.*;                   //import video
import java.awt.*;                           //import all java libraries

// -------------------------------- Declare capture(video) object
Capture video;
// -------------------------------- Declare picture taken, destination picture, histogram and histogram mask
PImage src, picture, dst, hist, histMask;
// -------------------------------- Declare bools to check if mouse or space is pressed, default = false
boolean mouseClicked, spacePressed;
// -------------------------------- Declare OpenCV object and Opencv mat (image) file
OpenCV opencv;
Mat skinHistogram;                          

void setup() { // ---------------------------------------------------------- Setup
 size(640, 960);                            //set up window size
 video = new Capture(this, 640/2, 480/2);   //set up video
 printArray(Capture.list());                //see webcam settings
 
 opencv = new OpenCV(this, video.width, video.height);
 video.start();
} // ----------------------------------------------------------------------- End of setup()

void draw() { // ----------------------------------------------------------- draw
  scale(2);
    
  if (video.available()) {
    video.read();
  } 
  opencv.loadImage(video);
  image(video, 0, 0 );
    
  //show text
  String s = "Mouseclick = take Picture, Space = Restart video";      
  fill(50);
  text(s, 10, 10, 100, 80);
  
} // ----------------------------------------------------------------------- End of draw()

void captureEvent(Capture video) {
  video.read();
} // ----------------------------------------------------------------------- captureEvent

void mouseClicked()          
{
  //set bool to true
  mouseClicked = true;
  
  //take picture
  image(video, 0, 0);
  saveFrame("data/picture.jpg");
  delay(300);
  video.stop();
  picture = loadImage("picture.jpg");          //load picture
  
  //make skinpicture
  src = opencv.getSnapshot();
  skinPicture(src);                            //call openCV method
} // ----------------------------------------------------------------------- mouseClicked

void keyPressed() {
  if (key == ' ')      // ' ' stands for space
  {
    //set bool to true
    spacePressed = true;
    
    //restart video
    video.start();
  }
} // ----------------------------------------------------------------------- keyPressed


void skinPicture(PImage pic){ // ------------------------------------------- openCV code
  /****************************************   
*          OPEN CV CODE                 *
*****************************************/
  opencv = new OpenCV(this, pic, true);
  
  skinHistogram = Mat.zeros(256, 256, CvType.CV_8UC1);
  Core.ellipse(skinHistogram, new Point(113.0, 155.6), new Size(40.0, 25.2), 43.0, 0.0, 360.0, new Scalar(255, 255, 255), Core.FILLED);
  
  histMask = createImage(256,256, ARGB);    //width, height, format
  opencv.toPImage(skinHistogram, histMask); //convert to PImage
  hist = loadImage("cb-cr.png");
  hist.blend(histMask, 0,0,256,256,0,0,256,256, ADD);
 
  dst = opencv.getOutput();
  dst.loadPixels();
  
  for(int i = 0; i < dst.pixels.length; i++){
    Mat input = new Mat(new Size(1, 1), CvType.CV_8UC3);
    input.setTo(colorToScalar(dst.pixels[i]));
    Mat output = opencv.imitate(input);
    Imgproc.cvtColor(input, output, Imgproc.COLOR_BGR2YCrCb );
    double[] inputComponents = output.get(0,0);
    if(skinHistogram.get((int)inputComponents[1], (int)inputComponents[2])[0] > 0){
      dst.pixels[i] = color(255);
    } else {
      dst.pixels[i] = color(0);
   }
}
dst.updatePixels();
image(dst, 0, 640, 640, 480);
}

 // in BGR
Scalar colorToScalar(color c){
  return new Scalar(blue(c), green(c), red(c));
} // ----------------------------------------------------------------------- colorToScalar
