/* This is the code for the tilt sensor used in our grass, based
on a simple sketch for controlling a light-emitting diode. */

// constants won't change. They're used here to 
// set pin numbers:
const int tiltPin = 2;     // the number of the tilt sensor pin
const int outPin =  13;      // the number of the LED pin

int tiltState = 0;         // variable for reading the tilt status

void setup() {
  // initialize the LED pin as an output:
  pinMode(outPin, OUTPUT);      
  // initialize the tilt sensor pin as an input:
  pinMode(tiltPin, INPUT);     
  Serial.begin(9600); 
}

void loop(){
  // read the state of the tilt value
  tiltState = digitalRead(tiltPin);

  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:
  if (tiltState == HIGH) {     
    // send 1 through serial    
    digitalWrite(outPin, HIGH);
    Serial.println(1);   
  } 
  else {
    // send 0 through serial
    digitalWrite(outPin, LOW);
    Serial.println(0);    
  }
}
