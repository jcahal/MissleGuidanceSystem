/*
*  Missile Gudance System
*
*  Jonathan Cahal
*  Chase Cook
* Hannah Van Den Bosch
* Kyle Ferguson
*
*  CSC 230 Summer 2015
*
*  Track a drone between radars and fire a missle to knock it out of the sky ninja style.
*
*  Given information:
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
*  Constraints:
*    Drone must be traveling < MACHII or missile can't catch it
*/

// External library includes
#include <math.h> // for high level math functions
#include <IOShieldOled.h>

// Constant PIN number variables
const int sysLED = 13; // system operational LED

const int LD1 = 70; // SW1 indicator
const int LD2 = 71; // SW2 indicator

const int LD3 = 72;
const int LD4 = 73;
const int LD5 = 74;
const int LD6 = 75;
const int LD7 = 76;
const int LD8 = 77;


const int SW1 = 2; // radar A - position: (5,0)
const int SW2 = 7; // radar B - position: (7,0)

// Other constant variables for calculations
const double MACHII = 0.4267;
const double D_ATOB = 2.828;
const int THETA_DRONE = 45;
const int TEST_CASE = 15000;

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

int launch_angle = 0;
int time_to_impact = 0;
int i = 0;

int timer = 0; // time it takes for drone to pass between radars
int tens = 0;
int ones = 0;
int tenths = 0;
int hundredths = 0;
int thousandths = 0;

int loadingStep = 0; // for use in loadingAnimation();

int state = 0;

// Functions
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
*  double distanceTo(double a, double b) - uses pythagorean theorem to find distance to impact
*
*  double timeTo(double d, double v) - time to travel distance
*
*  int toMiliseconds(double time) - converts a time to miliseconds
*
*  double toSeconds(int time) - converts a time to seconds
*
*  void displayTime(int time) - displays time up to 99.99 sec
*
*  void loadingAnimation() - displays a loading animation
*/

double calcDroneSpeed(double time) {
    return D_ATOB / time; // need to covert time
}

double calcDroneVelocityX(double s){
    return s * cos((THETA_DRONE * PI) / 180.00);
}

double calcLaunchAngle(double vector) {
    return acos(vector/MACHII) * (180.00 / PI);
}

double calcMissileSlope(double theta){
    return tan((theta * PI) / 180.00);
}

double calcImpactX(double slope){
    return ((slope * 7.0) + 1.0) / (slope - 1.0);
}

double calcImpactY(double x){
    return x + 1;
}

double distanceTo(double a, double b){
    return sqrt(pow(a, 2) + pow(b, 2));
}

double timeTo(double d, double v){
    return d / v;
}

int toMilliseconds(double time) {  // time cannot be greater than 99.99 seconds
    return (int)(time * 100);
}

double toSeconds(int time) {
    return ((double)time) / 100.00;
}

void displayTime(int time) {    // int time must be given in milliseconds
    tens = (time % 10000) / 1000;
    ones = (time % 1000) / 100;
    tenths = (time % 100) / 10;
    hundredths = time % 10;

    IOShieldOled.setCursor(0, 1); // tens
    IOShieldOled.putChar(tens + 48); // + 48 to convert to ASCII
    IOShieldOled.setCursor(1, 1); // ones
    IOShieldOled.putChar(ones + 48); // + 48 to convert to ASCII
    IOShieldOled.setCursor(2, 1);// deci
    IOShieldOled.putChar('.');
    IOShieldOled.setCursor(3, 1); // thenths
    IOShieldOled.putChar(tenths + 48); // + 48 to convert to ASCII
    IOShieldOled.putChar(tenths + 48); // + 48 to convert to ASCII
    IOShieldOled.setCursor(4, 1); // hundredths
    IOShieldOled.putChar(hundredths + 48); // + 48 to convert to ASCII
}

// TODO - complete this prototype
void loadingAnimation() {

}

// Setup function
void setup() {

    // Pin I/O declarations
    pinMode(LD1, OUTPUT);
    pinMode(LD2, OUTPUT);
    pinMode(LD1, OUTPUT);
    pinMode(LD2, OUTPUT);
    pinMode(LD3, OUTPUT);
    pinMode(LD4, OUTPUT);
    pinMode(LD5, OUTPUT);
    pinMode(LD6, OUTPUT);
    pinMode(LD7, OUTPUT);
    pinMode(LD8, OUTPUT);

    pinMode(SW1, INPUT);
    pinMode(SW1, INPUT);

    // Zero outputs
    digitalWrite(LD1, LOW);
    digitalWrite(LD2, LOW);
    digitalWrite(LD3, LOW);
    digitalWrite(LD4, LOW);
    digitalWrite(LD5, LOW);
    digitalWrite(LD6, LOW);
    digitalWrite(LD7, LOW);
    digitalWrite(LD8, LOW);

    // Display initalizers
    IOShieldOled.begin();
    IOShieldOled.setCursor(0, 0);

} // end - setup()

// Loop function
void loop() {

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

            while(SW2_state == LOW){
                //delay(1);
                timer++;

                displayTime(timer);

                SW2_state = digitalRead(SW2);
            }

            state = 2; // transition state 2

            break; // end - timing state

        case 2: // calculation state
            IOShieldOled.clear();
            IOShieldOled.setCursor(0, 0);
            IOShieldOled.putString("Calculating");

            displayTime(timer);
            delay(3000);

            drone_speed = calcDroneSpeed(toSeconds(timer));

            IOShieldOled.clear();
            IOShieldOled.setCursor(0, 0);
            IOShieldOled.putString("Drone Speed");

            drone_speed = calcDroneSpeed(toSeconds(timer));
            displayTime(toMilliseconds(drone_speed));
            delay(3000);

            if(drone_speed < MACHII) {

                drone_velocity_x = calcDroneVelocityX(drone_speed);

                missile_launch_angle = calcLaunchAngle(drone_velocity_x);

                missile_slope = calcMissileSlope(missile_launch_angle);

                impact_x = calcImpactX(missile_slope);

                impact_y = calcImpactY(impact_x);

                drone_d_to_impact = distanceTo((impact_x - 7), (impact_y - 8));

                missile_d_to_impact = distanceTo((impact_x - 7), impact_y);

                drone_t_to_impact = timeTo(drone_d_to_impact, drone_speed);

                missile_t_to_impact = timeTo(missile_d_to_impact, MACHII);

                state = 3; // goto launch state

            } else if(drone_speed > MACHII) {       // if drone_speed > MACHII display message and go to waiting

                IOShieldOled.clear();
                IOShieldOled.setCursor(0, 0);
                IOShieldOled.putString("Drone to Fast");

                delay(3000);

                state = 0; // go to waiting state
            }

            break;

        case 3: // launch state

            drone_t_to_impact = round(drone_t_to_impact * 100.00) / 100.00; // round to the hundredth place
            missile_t_to_impact = round(missile_t_to_impact * 100.00) / 100.00; // round to the hundredth place
            missile_launch_angle = round(missile_launch_angle * 100.00) / 100.00;

            if(drone_t_to_impact == missile_t_to_impact) {

                launch_angle = toMilliseconds(missile_launch_angle);

                IOShieldOled.clear();
                IOShieldOled.setCursor(0, 0);
                IOShieldOled.putString("Launch Angle:");
                displayTime(launch_angle);
                delay(2000);

                // Comment out for now
                if(i == 0) {
                    time_to_impact = toMilliseconds(missile_t_to_impact); // this will happen only once
                    i++;
                }

                IOShieldOled.clear();
                IOShieldOled.setCursor(0, 0);
                IOShieldOled.putString("Impact in:");

                while(time_to_impact > 0) {

                    displayTime(time_to_impact);
                    time_to_impact--;
                }

                IOShieldOled.clear();
                IOShieldOled.setCursor(0, 0);
                IOShieldOled.putString("It's a Hit!");

                state = 4;

            } else {

                IOShieldOled.clear();
                IOShieldOled.setCursor(0, 0);
                IOShieldOled.putString("Something went wrong");

                state = 0;
            }

            break;

        case 4:

            digitalWrite(LD3, HIGH);
            delay(20);
            digitalWrite(LD4, HIGH);
            delay(20);
            digitalWrite(LD5, HIGH);
            delay(20);
            digitalWrite(LD6, HIGH);
            delay(20);
            digitalWrite(LD7, HIGH);
            delay(20);
            digitalWrite(LD8, HIGH);
            delay(20);
            digitalWrite(LD8, LOW);
            delay(20);
            digitalWrite(LD7, LOW);
            delay(20);
            digitalWrite(LD6, LOW);
            delay(20);
            digitalWrite(LD5, LOW);
            delay(20);
            digitalWrite(LD4, LOW);
            delay(20);
            digitalWrite(LD3, LOW);
            delay(20);

            if(SW1_state == LOW and SW2_state == LOW) {state = 0;}

            break;
    } // end - switch(state)

    IOShieldOled.updateDisplay();

} // end - loop()
