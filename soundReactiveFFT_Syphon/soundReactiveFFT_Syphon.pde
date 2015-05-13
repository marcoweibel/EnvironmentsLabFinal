//Marco Weibel - Core Studio/Lab Environments Final

//Thanks to Andy Best and his tutorial on FFT
//http://andybest.net/2010/01/5-processing-video-tutorials

import ddf.minim.*;
import ddf.minim.analysis.*;

//Send syphon
import codeanticode.syphon.*;
SyphonServer server;



//minim object
Minim minim;
//Create audio input
AudioInput in;
//Fast fourier transform
FFT fft;

// int to divide the width of the sketch 
int w;

//PImage Layer for creating fading effect
PImage fade;

//Create variable for Hue value
int hValue;

//width & height of PImage
float rWidth, rHeight;

void setup () {
  size (640, 480, P3D);
  
  //initialize the new Minum object
  minim = new Minim(this); 
  in = minim.getLineIn(Minim.STEREO, 512);
  
  //initialize fft
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  //logAverages(minBandwidth, bandsPerOctave);
  fft.logAverages(60,7);

  //set stroke to white
  stroke (255,0,0);
  
  //make the width of the line equal to the spacing of each avg
  w = width/fft.avgSize();
  
  //create space between each stroke
  strokeWeight(w/2);
  
  strokeCap(SQUARE);
  
  background(0);
  
  //load imagine
  fade = get(0,0,width,height);
  
  rWidth = width *0.99;
  rHeight = height * 0.99;
  
  hValue = 0;
  
    // Create syhpon server to send frames out.
    server = new SyphonServer(this, "Processing Syphon");
}

void draw() {
  
  background(0);
  
  //draw fade image 
  tint(255,255,255,254.9999);
  image(fade,(width - rWidth)/2,0, rWidth, rHeight);
  noTint();
  
  //set up the fft for this frame
  fft.forward(in.mix);
  
  //cycle thru rainbow of colors
  colorMode(HSB);
  stroke (hValue,255,255);
  colorMode(RGB);
  
  //pull different fft bands out of fft
  for (int i=0; i <fft.avgSize(); i++) {
   line ((i*w), height, (i*w), height -fft.getAvg(i) *4);  
  }
    fade = get(0,0,width,height);
    
    //add 2 at the end of every frame
    
    hValue += 2;
    if (hValue > 255) {
      hValue = 0; 
    }
    
    //send screen to syphon server 
      server.sendScreen();
}
