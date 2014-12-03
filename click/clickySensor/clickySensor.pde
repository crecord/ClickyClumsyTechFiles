import processing.serial.*;
import ddf.minim.*;

Minim minim;
 AudioPlayer sound;
int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port
float pressureValue; 
float p0;
float p1;

void setup() {
  // List all the available serial ports
  println(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;
  
  minim = new Minim(this);
  sound = minim.loadFile("clickClick.mp3");
  sound.loop(); 
  sound.setGain(5);
}

void draw() {
  while (myPort.available() > 0) {
    //This code assumes we have two pressure sensors
    //hooked up to the Arduino. If there is only one,
    //then only one of these values will be nonzero
    //and most of the logic becomes trivial.
    myString = myPort.readStringUntil(lf);
    p0 = 0.0;
    p1 = 0.0;
    println(myString);
    
    //Grab the two values
    if (myString != null){
        p0 = float(myString.substring(0,1));
        p1 = float(myString.substring(2));
    }
    
    //Check to see which value is greater, in either
    //case map the volume of the click noise being 
    //played to the voltage running through the one
    //with more pressure applied.
    pressureValue = (p0 > p1) ? p0 : p1;
    println("P0: " +p0);
    println("P1: " +p1);
    int value = int(map(pressureValue, 0,3,-60,0)); 
    sound.setGain(value);
      
  }
}
