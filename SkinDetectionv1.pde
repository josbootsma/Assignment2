//libraries
import gab.opencv.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.imgproc.Imgproc;   //import openCV
import processing.video.*;           //import video
import java.awt.*;                   //import all java libraries

//Declare capture(video) object
Capture video;
//source file, destination file
PImage dst;

OpenCV opencv;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  
  //see webcam settings
  printArray(Capture.list());
  
  video.start();
}

void draw() {
  scale(2);
  opencv.loadImage(video);
  
  image(video, 0, 0 );

}

void captureEvent(Capture c) {
  c.read();
}
