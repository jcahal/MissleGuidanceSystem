/*
*  Missle Gudance System 
*  
*  Jonathan Cahal
*  
*  CSC 230 Summer 2015 
* 
*  Track a drone between radars and fire a missle to knock it out of the sky ninja style.
*
*  Given information:
*
*  
*    Radar A position: (5, 0)
*    Radar B position: (7, 0)
*
*    Drone P1 position: (5, 6)
*    Drone P1 position: (7, 8)
*
*    Distance, P1 to P2: d1 = 2.828 miles
*
*    Drone speed: s = d1/t, (d1/15 = 0.1885 miles/second)
*    Drone equation: y = x + 1
*    Drone angle: theta1 = 45 degrees
*    Drone velocity x: vx = s * cos(theta1), (0.1885 * cos(45) = 0.1333 miles/second)
*    Drone x coordinate: x(drone) = x2 + vx * t, (7 + 0.1333 * 15 = 8.9995 miles)
*
*    Missile speed: MACHII = .4266 miles/second
*    Missile equation: y = mx - 7m
*    Missile velocity x: vx = MACHII * cos(theta2) 
*    Missile x coordinate: x(missile) = x2 + vx * t, (7 + (MACHII * cos(theta2)) * t)
*
*    For missile to hit drone x(missile) == x(drone)
*
*  TODO:
*    Get time of drone between radar A and radar B. DONE
*    Calculate speed of drone. DONE
*    Calculate the velocity of drone in x direction. DONE
*    Calculate launch angle of missile (theta2). DONE
*    Calculate missiles linear slope. DONE
*    Calculate x coordinate at time of impact. DONE
*    Calculate y coordinate at time of impact. DONE
*    Calculate drone distance to coordinate of impact. DONE
*    Calculate missile distance to coordinate of impact. DONE
*    Calculate time for drone to reach coordinate of impact. DONE
*    Calculate time for missile to reach coordinate of impact. DONE
*    Verify time for drone to reach impact coordinate (t1) == time for missile to reach coordinate of impact (t2). STATE 3
*    DECLARE VICTORY!! STATE 4
*
*
*  Constraints:
*    
*    Drone must be traveling < MACHII or missile can't catch it
*/

// External library includes
#include <math.h> // for high level math functions
#include <IOShieldOled.h>

// Constant PIN number variables
const int sysLED = 13; // system operational LED

const int LD1 = 70; // SW1 indicator
const int LD2 = 71; // SW2 indicator

const int SW1 = 2; // radar A - position: (5,0)
const int SW2 = 7; // radar B - position: (7,0)

// Other constant variables for calculations
const double MACHII = 0.4267;
const double D_ATOB = 2.828;
const int THETA_DRONE = 45;

// Overwritables 
int SW1_state = 0;
int SW2_state = 0;

double drone_speed = 0.0;
double drone_velocity_x = 0.0;
double missile_launch_angle = 0.0;
double missile_slope = 0.0;
double impact_x = 0.0;
double impact_y = 0.0;
double drone_d_to_impact = 0.0;
double missile_d_to_impact = 0.0;
double drone_t_to_impact = 0.0;
double missile_t_to_impact = 0.0;

int time_to_impact = 0;
int i = 0;

int timer = 0; // time it takes for drone to pass between radars
int tens = 0;
int ones = 0;
int tenths = 0;
int hundredths = 0;

int loadingStep = 0; // for use in loadingAnimation();

int state = 0;

// Functions \\
/*
*  double calcDroneSpeed(int time) - speed from time in miliseconds, uses distance between radar A and B
*
*  double calcDroneVelocityX(double s) - takes speed and calculate velocity 
*
*  double calcLaunchAngle(double vector) - takes vector (vx/MACHII) to find angle missile needs to launch at
*
*  double calcMissileSlope(double theta) - takes theta and returns slope
*
*  double calcImpactX(double theta) - x coordinate at time of impact
*
*  double calcImpactY(double x) - y coordinate at time of impact
*
*  double distanceToImpact(double a, double b) - uses pythagorean theorem to find distance to impact
*
*  double timeToImpact(double d, double v) - time to travel distance
*
*  int toMiliseconds(double time) - converts a time to miliseconds
*
*  double toSeconds(int time) - converts a time to seconds
*
*  void displayTime(int time) - displays time up to 99.99 sec
*
*  void loadingAnimation() - displays a loading animation
*/

double calcDroneSpeed(int time) {
   return D_ATOB / toSeconds(time); // need to covert time 
}

double calcDroneVelocityX(double s){
   return s * cos(THETA_DRONE); 
}

double calcLaunchAngle(double vector) {
   return acos(vector/MACHII);
}

double calcMissileSlope(double theta){
   return tan(theta);
}

double calcImpactX(double slope){
   return (slope - 1.0) / ((slope * 7.0) - 1.0);
}

double calcImpactY(double x){
   return x + 1;
}

double distanceTo(double a, double b){
   return sqrt(pow(a, 2) + pow(b, 2));
}

double timeToImpact(double d, double v){
   return d / v;
}

int toMilliseconds(double time) {  // time cannot be greater than 99.99 seconds
   return (int)time * 100;
}

double toSeconds(int time) {
   return ((double)time) / 1000.00;
}

void displayTime(int time) {    // int time must be given in milliseconds
   tens = (time % 10000) / 1000;
   ones = (time % 1000) / 100;
   tenths = (time % 100) / 10;
   hundredths = time % 10;
  
   IOShieldOled.setCursor(1, 1); // tens
   IOShieldOled.putChar(tens + 48); // + 48 to convert to ASCII
   IOShieldOled.setCursor(2, 1); // ones
   IOShieldOled.putChar(ones + 48); // + 48 to convert to ASCII
   IOShieldOled.setCursor(3, 1); // deci
   IOShieldOled.putChar('.'); // + 48 to convert to ASCII
   IOShieldOled.setCursor(4, 1); // thenths
   IOShieldOled.putChar(tenths + 48); // + 48 to convert to ASCII
   IOShieldOled.setCursor(5, 1); // hundredths
   IOShieldOled.putChar(hundredths + 48); // + 48 to convert to ASCII
}

// TODO - complete this prototype
void loadingAnimation() {

}

// Setup function
void setup() {
     
  // Pin I/O declarations
  pinMode(sysLED, OUTPUT);
  pinMode(LD1, OUTPUT);
  pinMode(LD2, OUTPUT);
  
  pinMode(SW1, INPUT);
  pinMode(SW1, INPUT);
  
  // Zero outputs
  digitalWrite(LD1, LOW);
  digitalWrite(LD2, LOW);
  
  // Display initalizers
  IOShieldOled.begin();
  IOShieldOled.setCursor(0, 0); 
   
} // end - setup()

// Loop function
void loop() {
  
  // System operational indication
  //digitalWrite(sysLED, HIGH); // sysLED HIGH 
  //delay(50);
  
  
  // Map SW_states to SW's
  SW1_state = digitalRead(SW1);
  SW2_state = digitalRead(SW2);
  
  // Indicate SW_states on LD's
  if(SW1_state == HIGH) {digitalWrite(LD1, HIGH);}
  if(SW1_state == LOW) {digitalWrite(LD1, LOW);}
  if(SW2_state == HIGH) {digitalWrite(LD2, HIGH);}
  if(SW2_state == LOW) {digitalWrite(LD2, LOW);}
 
  
  // State Machine
  /*
  *
  *  State 0 - waiting state
  *  State 1 - timing state
  *  State 2 - calculation state
  *  State 3 - launch state
  *  State 4 - declare VICTORY!
  *
  */
     
  switch(state) {
   case 0: // waiting state
     IOShieldOled.clear();
     IOShieldOled.setCursor(0, 0);
     IOShieldOled.putString("Waiting"); 
     
     
     timer = 0; // reset timer to 0 in anticipation of next timing state
     i = 0; // reset iterator for use
   
     // radar A triggered - transition timing state  
     if(SW1_state == HIGH) {state = 1;}
     
     break; // end - waiting state 

   case 1: // timing state
   
     // this is for development diagnostics, 
     // REMOVE BEFORE PRODUCTION TO CONSERVE GREATEST TIMING ACCURACY
     IOShieldOled.clear();
     IOShieldOled.setCursor(0, 0);
     IOShieldOled.putString("Timing");

     // clock at 1ms frequency    
     delay(1);
     timer++;
     
     // this is for development diagnostics, 
     // REMOVE BEFORE PRODUCTION TO CONSERVE GREATEST TIMING ACCURACY
     displayTime(timer);
   
     // radar B triggered - transition calculation state
     if(SW2_state == HIGH) {state = 2;}
   
     break; // end - timing state
     
   case 2: // calculation state
     IOShieldOled.clear();   
     IOShieldOled.setCursor(0, 0);
     IOShieldOled.putString("Calculating");
     
     drone_speed = calcDroneSpeed(timer);
     
     if(drone_speed < MACHII) {
       
       drone_velocity_x = calcDroneVelocityX(drone_speed);
      
       missile_launch_angle calcLaunchAngle(drone_velocity_x);
       
       missile_slope calcMissileSlope(missile_launch_angle);
       
       impact_x = calcImpactX(missile_slope);
        
       impact_y calcImpactY(impact_x);
       
       drone_d_to_impact = distanceTo((impact_x - 7), (impact_y - 8));
        
       missile_d_to_impact = distanceTo((impact_x - 7), impact_y);
       
       drone_t_to_impact = timeTo(drone_d_to_impact, drone_speed);
       
       missile_t_to_impact = timeTo(missile_d_to_impact, MACHII);
       
     } else {                                  // if drone_speed > MACHII display message and go to waiting
       IOShieldOled.clear();   
       IOShieldOled.setCursor(0, 0);
       IOShieldOled.putString("Drone to Fast"); 
       
       delay(3000);
       
       state = 0;
     }
 
     state = 3;
     
     break;
     
   case 3: // launch state
   
     if(drone_t_to_impact == missile_t_to_impact) {

       do {
         time_to_impact = toMilliseconds(missile_t_to_impact); // this will happen only once  
       } while(++i == 0); 
       
     } else {
       
       IOShieldOled.clear();   
       IOShieldOled.setCursor(0, 0);
       IOShieldOled.putString("Something went wrong");
       
     }
     
       IOShieldOled.clear();   
       IOShieldOled.setCursor(0, 0);
       IOShieldOled.putString("Impact in:");
       
       displayTime(time_to_impact);
       time_to_impact--;
   
     break;
     
  }
   
  
  
   // System operational indication
   //digitalWrite(sysLED, LOW); // sysLED LOW 
   //delay(50);
   
   IOShieldOled.updateDisplay();
  
} // end - loop()
