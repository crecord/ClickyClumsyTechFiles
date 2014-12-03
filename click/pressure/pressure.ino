// We assume two pressure sensors connected
// to analog inputs A0 and A1.
int sensorPin0 = A0; 
int sensorPin1 = A1;
int sensorValue0 = 0;  
int sensorValue1 = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  // Read the value from the sensor:
  sensorValue0 = analogRead(sensorPin0);    
  sensorValue1 = analogRead(sensorPin1);  

  // Since these values are 0-1023, convert them
  // to an actual voltage value.
  sensorValue0 = sensorValue0 * (5.0 / 1023.0); 
  sensorValue1 = sensorValue1 * (5.0 / 1023.0);  
 
  // Print the voltages to the serial
  Serial.print(sensorValue0); 
  Serial.print(",");
  Serial.println(sensorValue1);
  
  // Stop the program for 200 milliseconds:
  delay(200);                           
}
