import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer sound;
int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;  // The serial port
//Flag for finding if the app is reading from
//the serial with no prior instance of doing so
boolean firstRead;
//Previously read x,y,z values
float pX = 0;
float pY = 0;
float pZ = 0;


void setup() {
  firstRead = true;
  // List all the available serial ports
  println(Serial.list());
  // Open the port you are using at the rate you want,
  // in most cases it will be 9600 Hz:
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;
  
  // Create a new Minim instance and load in our sound.
  minim = new Minim(this);
  sound = minim.loadFile("rock_4.wav");
  sound.loop(); 
  // Set the gain very low so it cannot be heard at start
  sound.setGain(-60);
}

void draw() {
  while (myPort.available() > 0) {
    //Read in a string from the serial
    myString = myPort.readStringUntil(lf);
    println(myString);
    
    if(myString != null){
      //Split the string you read into tokens, convert
      //them to useable numbers.
      //Remember the accelerometer reads orientation as
      //three different float values, x y z.
      String[] tok = splitTokens(myString, "\t");
      float c0 = float(tok[0]);
      float c1 = float(tok[1]);
      float c2 = float(tok[2]);
      
      if(!firstRead){
        //Take the dot product of the previously read orientations
        //and the orientations you just read
        float dot = pX*c0+pY*c1+pZ*c2;
        float cMag = sqrt(c0*c0+c1*c1+c2*c2);
        float pMag = sqrt(pX*pX+pY*pY+pZ*pZ); 
        
        //Solve for cos(theta), then solve for theta
        float val = dot/(cMag*pMag);
        float angle = acos(val);
        
        println(degrees(angle));
        
        //If the change in angle indicated by theta is
        //large enough, play the sound by setting the 
        //gain to a normal level
        if(degrees(angle) > 25){
          sound.setGain(0);
        }
        else{
          sound.setGain(-60); 
        }
        
        pX=c0;
        pY=c1;
        pZ=c2;
      }
      else{
        //If this is the first time we are reading
        //from the serial, fill our previous xyz values
        pX = c0;
        pY = c1;
        pZ = c2;
        firstRead = false; 
      } 
    }
  }
}
