#!/usr/bin/env python3
from ev3dev.ev3 import *
import math

RADIUS = 0.022
BRADIUS = 0.2

mA = LargeMotor('outA')
mB = LargeMotor('outB')

def pi_mod(n):
	return -(abs(n) % math.pi) if abs(n) > math.pi else n

def input_coords():
	all_points = []
	num_points = int(input('how many coordinates ? '))
	for i in range(num_points):
		print('point n° {}'.format(i))
		x, y = float(input('x= ')), float(input('y= '))
		all_points.append((x, y))
	return all_points

def run_motors(orientation_diff, goal_dist):
	K1 = 100
	K2 = 250
	MAX_POWER = 100
	MAX_P_COEF = 50
	
	u1 = K1 * orientation_diff
	u2 = K2 * goal_dist * math.cos(orientation_diff)
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
	all_points = input_coords()
	previous_theta = 0

	for i in range(len(all_points)):
		x = y = last_x = last_y = last_l = 0
		mA.position = 0
		mB.position = 0
		
		current_point = all_points[i]
		previous_point = (0,0) if i == 0 else all_points[i - 1]

		goal_x = current_point[0] - previous_point[0]
		goal_y = current_point[1] - previous_point[1]
		goal_dist = dist_left = math.sqrt(goal_x ** 2 + goal_y ** 2)
	
		#print('goal_orientation: ', math.degrees(math.atan2(goal_y, goal_x)), '\n')
		
		#angle between OX and goal point
		goal_orientation = pi_mod(math.atan2(goal_y, goal_x) - previous_theta)
		#print('previous_theta: ', math.degrees(previous_theta), '\n')

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
			dist_traveled = math.sqrt(x ** 2 + y ** 2)
			last_l = dist_rolled
			
			#angle robot still has to turn to equal goal_orientation
			orientation_diff = pi_mod(goal_orientation - current_orientation)
			
			dist_left = 	goal_dist - dist_traveled

			run_motors(orientation_diff, goal_dist)

			#print('G_D ', 'G_X', '   x   ', 'G_Y', ' y', '  current_orientation  ', 'goal_orientation')
			#print("%.2f %.2f %.2f %.2f %.2f %.2f %.2f" % (goal_dist, goal_x, x, goal_y, y, math.degrees(current_orientation), math.degrees(goal_orientation)), '\n')

		stop_motors()
		
		previous_theta = goal_orientation + previous_theta
		
if __name__ == "__main__":
	main()