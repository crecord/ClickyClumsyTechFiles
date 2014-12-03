/*
This is the code for playing sounds based on the grass tilt sensor.
The main challenge here is just figuring out how to use minim with
multiple sounds on loop as opposed to just one.
*/

import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer sound1;
AudioPlayer sound2;
AudioPlayer sound3;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port
int tiltValue; 
int lastValue; 

void setup() {
  lastValue = 0; 
  // List all the available serial ports
  println(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[2], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;
  minim = new Minim(this);
  sound1 = minim.loadFile("rustle_1.wav");
  sound2 = minim.loadFile("rustle_2.wav");
  sound3 = minim.loadFile("rustle_3.wav");

  //For each sound, set the gain normally 
  sound1.setGain(0);
  sound2.setGain(0);
  sound3.setGain(0);

}

void draw() {
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
    
      tiltValue = int(float(myString));
     
      //Main logic. First check if any of the sounds are
      //already playing. 
      if(tiltValue != lastValue && 
        !(sound1.isPlaying() || sound2.isPlaying()
        || sound3.isPlaying())){
        int n = (int)random(2);

        //Take the randomly generated n and choose a sound
        //to play.
        if(n == 0){
          sound1.pause();
          sound1.rewind();
          sound1.play(); 
          println("true: " + sound1.isPlaying());  
        }
        else if(n == 1){
          sound2.pause();
          sound2.rewind();
          sound2.play(); 
          println("true: " + sound2.isPlaying());
        }
        else{
          sound3.pause();
          sound3.rewind();
          sound3.play();  
          println("true: " + sound3.isPlaying());
        }
        println("sound play");
      }
      //Because the balls in the tilt sensor generally stay in place unless
      //more tilting happens, we just keep track of the previous tilt value.
      lastValue = tiltValue;
    }
  }
}


void stop()
{
  // always close Minim audio classes when you are done with them
  sound1.close();
  sound2.close();
  sound3.close();

  // always stop Minim before exiting.
  minim.stop(); 
  super.stop();
}
