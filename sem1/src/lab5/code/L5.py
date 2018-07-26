#!/usr/bin/env python3
from ev3dev.ev3 import *
import math

RADIUS = 0.022
BRADIUS = 0.178

mA = LargeMotor('outA')
mB = LargeMotor('outB')


def pi_mod(n):
	return n - math.copysign(1,n) * 2 * math.pi if abs(n) > math.pi else n

def input_coords():
	x, y = float(input('x= ')), float(input('y= '))
	return [x,y]

def run_motors(orientation_diff, goal_dist):
	K1 = 200
	K2 = 250
	MAX_POWER = 99
	MAX_P_COEF = 100
	
	u1 = K1 * orientation_diff
	u2 = K2 * goal_dist 
	if (abs(u1) > MAX_P_COEF):
		u1 = math.copysign(1, u1) * MAX_P_COEF
	if (abs(u2) > MAX_P_COEF):
		u2 = math.copysign(1, u2) * MAX_P_COEF
	
	pwr_A = u2 + u1
	pwr_B = u2 - u1
	if (abs(pwr_A) > MAX_POWER):
		pwr_A = math.copysign(1, pwr_A) * MAX_POWER
	if (abs(pwr_B) > MAX_POWER):
		pwr_B = math.copysign(1, pwr_B) * MAX_POWER
	

	mA.run_direct(duty_cycle_sp=pwr_A)
	mB.run_direct(duty_cycle_sp=pwr_B)
	
def stop_motors():
	mA.stop(stop_action='brake')
	mB.stop(stop_action='brake')

def main():
	point = input_coords()
	filename = input("Filename: ")
	f = open (filename + '.txt','w')
	previous_theta = 0
	x = y = last_x = last_y = last_l = 0
	mA.position = 0
	mB.position = 0
	

	goal_x = point[0]
	goal_y = point[1] 

	goal_orientation = pi_mod(math.atan2(goal_y, goal_x) - previous_theta)
	goal_dist = dist_left = math.sqrt(goal_x ** 2 + goal_y ** 2)

	while dist_left > 0.05:
		motor_rotations_A = mA.position
		motor_rotations_B = mB.position
		avg_motor_rotations = math.radians((motor_rotations_A + motor_rotations_B) / 2)
		
		#robot's orientation to OX
		current_orientation = math.radians((motor_rotations_A - motor_rotations_B) * RADIUS / BRADIUS)
		dist_rolled = avg_motor_rotations * RADIUS
		l = dist_rolled - last_l
		x = l * math.cos(current_orientation) + x
		y = l * math.sin(current_orientation) + y
		f.write(str(x) +' '+ str(y)+'\n')
		dist_traveled = math.sqrt(x ** 2 + y ** 2)
		last_l = dist_rolled
		
		#angle robot still has to turn to equal goal_orientation
		orientation_diff = pi_mod(math.atan2(goal_y-y, goal_x-x) - current_orientation)
		
		dist_left = 	goal_dist - dist_traveled

		run_motors(orientation_diff, goal_dist)

		
	stop_motors()
	
		
if __name__ == "__main__":
	main()
