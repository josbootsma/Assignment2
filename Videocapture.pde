import processing.video.*;

Particle[] particles;
Capture video;
Capture frog;

void setup(){
  //size (displayWidth, displayHeight);
  size (1280, 720);
  
  printArray(Capture.list());
  
  frog = new Capture(this, 640,480);
  frog.start();
  
  particles = new Particle [100];
  for (int i = 0; i < particles.length; i++){
    particles[i] = new Particle();
  }
  //video = new Capture(this, 640,480, 30);
  //video.start();
  
  background(0);
}

/*void mousePressed(){
  video.read();
}*/

void captureEvent(Capture video){
  video.read();
}

void draw() {
  
  for (int i =0; i < particles.length; i++){
    particles[i].display();
    particles[i].move();
  }  

}