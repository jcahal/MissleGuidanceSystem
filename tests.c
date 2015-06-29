#include <stdio.h>


const double D_ATOB = 2.828;
int t = 1500;

double result = 0.0;


double calcDroneSpeed(int time) {
   return D_ATOB / (double)time; // need to covert time 
}

/*
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

double timeTo(double d, double v){
   return d / v;
}

int toMilliseconds(double time) {  // time cannot be greater than 99.99 seconds
   return (int)time * 100;
}*/

double toSeconds(int time) {
   return ((double)time) / 100.00;
}


int main() {
	printf("%f\n", calcDroneSpeed(toSeconds(t)));
	printf("%f\n", toSeconds(t));
}