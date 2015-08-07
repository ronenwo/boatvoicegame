/**
 * This sketch demonstrates how to monitor the currently active audio input 
 * of the computer using an AudioInput. What you will actually 
 * be monitoring depends on the current settings of the machine the sketch is running on. 
 * Typically, you will be monitoring the built-in microphone, but if running on a desktop
 * it's feasible that the user may have the actual audio output of the computer 
 * as the active audio input, or something else entirely.
 * <p>
 * Press 'm' to toggle monitoring on and off.
 * <p>
 * When you run your sketch as an applet you will need to sign it in order to get an input.
 * <p>
 * For more information about Minim and additional features, 
 * visit http://code.compartmental.net/minim/ 
 */

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;
float hertz;//frequency in hertz
int sampleRate= 44100;//sapleRate of 44100
float [] max= new float [sampleRate/2];//array that contains the half of the sampleRate size, because FFT only reads the half of the sampleRate frequency. This array will be filled with amplitude values.
float maximum;//the maximum amplitude of the max array
float frequency;//the frequency in hertz
PImage boat ;

int xb = -300 ;
int yb = 570;

void setup()
{
  size(1024, 800, P3D);

  boat = loadImage("boat.png");

  minim = new Minim(this);

  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();
  fft = new FFT(in.left.size(), sampleRate);

  frameRate(20);
}

void draw()
{
  background(#021560 );
  stroke(255);




  // draw the waveforms so we can see what we are monitoring
  for (int i = 0; i < in.bufferSize () - 1; i++) {
    for (int k = 150; k < 450; k+=50)
    {
      line( i, k + in.left.get(i)*800, i+1, k + in.left.get(i+1)*800 );
    }
    for (int k = 450; k < 600; k+=30)
    {
      line( i, k + in.right.get(i)*800, i+1, k + in.right.get(i+1)*800 );
    }
    for (int k = 600; k < 880; k+=20)
    {
      line( i, k + in.left.get(i)*800, i+1, k + in.left.get(i+1)*800 );
    }
  }



  fft.forward(in.left);
  for (int f=0; f<sampleRate/2; f++) { //analyses the amplitude of each frequency analysed, between 0 and 22050 hertz
    max[f]=fft.getFreq(float(f)); //each index is correspondent to a frequency and contains the amplitude value
     
  }
  maximum=max(max);//get the maximum value of the max array in order to find the peak of volume

  for (int i=0; i<max.length; i++) {// read each frequency in order to compare with the peak of volume
    if (max[i] == maximum) {//if the value is equal to the amplitude of the peak, get the index of the array, which corresponds to the frequency
      frequency= i;
    }
  }
  maximum = maximum * 1000;

  image(boat, xb, yb, 122, 155) ;

  xb = xb + 1 ;
  if (xb > 1074) {
    xb = -300 ;
  }

  text( "frequency=" + frequency , 500, 15 );
  text( "max volume=" + maximum , 500, 35 );
  if (maximum > 550) {
    yb = yb - 1;
  }
  else{
    yb = yb + 3;
  }
  if (yb > 800) {
    yb = 70 ;
  }
  if (yb < -300) {
    yb = 70;
  }


  String monitoringState = in.isMonitoring() ? "enabled" : "disabled";
  text( "Input monitoring is currently " + monitoringState + ".", 5, 15 );
}

void keyPressed()
{
  if ( key == 'm' || key == 'M' )
  {
    if ( in.isMonitoring() )
    {
      in.disableMonitoring();
    } else
    {
      in.enableMonitoring();
    }
  }
}

