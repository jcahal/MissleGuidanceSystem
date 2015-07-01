#Missile Guidance System
  Jonathan Cahal
   
CSC 230 Summer 2015 

Track a drone between radars and fire a missle to knock it out of the sky ninja style.

Given information:
 Radar A position: (5, 0)
 Radar B position: (7, 0)

 Drone P1 position: (5, 6)
 Drone P1 position: (7, 8)

 Distance, P1 to P2: d1 = 2.828 miles

 Drone speed: s = d1/t, (d1/15 = 0.1885 miles/second)
 Drone equation: y = x + 1
 Drone angle: theta1 = 45 degrees
 Drone velocity x: vx = s   cos(theta1), (0.1885   cos(45) = 0.1333 miles/second)
 Drone x coordinate: x(drone) = x2 + vx   t, (7 + 0.1333   15 = 8.9995 miles)

 Missile speed: MACHII = .4266 miles/second
 Missile equation: y = mx - 7m
 Missile velocity x: vx = MACHII   cos(theta2) 
 Missile x coordinate: x(missile) = x2 + vx   t, (7 + (MACHII   cos(theta2))   t)

 For missile to hit drone x(missile) == x(drone)

TODO:
 DECLARE VICTORY!! STATE 4


Constraints:
 Drone must be traveling < MACHII or missile can't catch it