// External library includes
#include <math.h>

// Other constant variables for calculations
const double MACHII = 0.4267;
const double D_ATOB = 2.828;
const double THETA_DRONE = 45.00;
const double PI = 3.14159265;

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

double time_to_impact = 0.0;

double foo = 0.0;

int timer = 15000; // time it takes for drone to pass between radars
int tens = 0;
int ones = 0;
int tenths = 0;
int hundredths = 0;

int loadingStep = 0; // for use in loadingAnimation();

int state = 0;


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
    return (int)(time * 1000);
}

double toSeconds(int time) {
    return ((double)time) / 1000.00;
}


int main() {

    drone_speed = calcDroneSpeed(toSeconds(timer));

    drone_velocity_x = calcDroneVelocityX(drone_speed);

    missile_launch_angle = calcLaunchAngle(drone_velocity_x);

    missile_slope = calcMissileSlope(missile_launch_angle);

    impact_x = calcImpactX(missile_slope);

    impact_y = calcImpactY(impact_x);

    drone_d_to_impact = distanceTo((impact_x - 7), (impact_y - 8));

    missile_d_to_impact = distanceTo((impact_x - 7), impact_y);

    drone_t_to_impact = timeTo(drone_d_to_impact, drone_speed);

    missile_t_to_impact = timeTo(missile_d_to_impact, MACHII);

    //Debug statements
    printf("Drone Speed: %f\n", drone_speed);
    printf("MACHII: %f\n", MACHII);
    printf("Drone Vx: %f\n", drone_velocity_x);
    printf("Missile Launch Angle  %f\n", missile_launch_angle);
    printf("Missile Slope: %f\n", missile_slope);
    printf("Impact X: %f\n", impact_x);
    printf("Impact Y: %f\n", impact_y);
    printf("Drone D to Impact: %f\n", drone_d_to_impact);
    printf("Missile D to Impact: %f\n", missile_d_to_impact);
    printf("Drone t to Impact: %f\n", drone_t_to_impact);
    printf("Missile t to Impact: %f\n", missile_t_to_impact);
    printf("Time to impact: %d\n", toMilliseconds(round(missile_t_to_impact * 100.00) / 100.00));

    if(drone_speed < MACHII) {
        printf("drone_speed < MACHII");
    } else {
        printf("drone_speed > MACHII");
    }

    if((round(drone_t_to_impact * 100) / 100) == (round(missile_t_to_impact * 100) / 100)) {
        time_to_impact = round(missile_t_to_impact * 100) / 100;

        //while(time_to_impact > 0.0) {
           // printf("%f\n", time_to_impact);
            //time_to_impact = time_to_impact - 0.01;
        //}

        printf("\n");
        printf("It's a Hit!!");
    } else {printf("we got issues");}
}
