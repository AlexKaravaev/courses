#!/usr/bin/env python3
from ev3dev.ev3 import *
import math

RADIUS = 0.022
BRADIUS = 0.2

mA = LargeMotor('outA')
mB = LargeMotor('outB')
alpha = 0
beta = 0
def pi_mod(n):
	return -(abs(n) % math.pi) if abs(n) > math.pi else n

"""def input_coords():
	all_points = []
	num_points = int(input('how many coordinates ? '))
	for i in range(num_points):
		print('point n° {}'.format(i))
		x, y = float(input('x= ')), float(input('y= '))
		all_points.append((x, y))
	return all_points"""

def run_motors(orientation_diff, beta, goal_dist):
	Kp = 150
	Kalpha = 150
	Kbeta = -50
	kIp = 2
	Kia = 2
	kIb = 2
	MAX_POWER = 100
	MAX_P_COEF = 50
	
	u1 = Kalpha * orientation_diff + Kbeta * beta + kIb * eIb + kIa * eIa
	u2 = Kp * goal_dist + kIp*eI
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
	global e0a, e1a, eIa,e0p, e1p, eIp, e0b, e1b, eIb
	goal_x = float(input("x = "))
	goal_y = float(input("y = "))
	beta = math.radians(float(input("desired angle = ")))
	previous_theta = 0

	x = y = last_x = last_y = last_l = 0
	mA.position = 0
	mB.position = 0
		
	goal_dist = dist_left = math.sqrt(goal_x ** 2 + goal_y ** 2)

	#print('goal_orientation: ', math.degrees(math.atan2(goal_y, goal_x)), '\n')
	
	#angle between OX and goal point
	goal_orientation = orientation_diff = pi_mod(math.atan2(goal_y, goal_x) - previous_theta)
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
		#dist_traveled = math.sqrt(x * x + y * y)
		last_l = dist_rolled
		

		orientation_diff = pi_mod(math.atan2(goal_y-y,goal_x-x) - current_orientation)
		beta = - current_orientation - orientation_diff
		dist_left = math.sqrt((goal_x - x) ** 2 + (goal_y - y) ** 2)
		e1p = dist_left
		eIp = e1 - e0
		e0p = e1
		e1a = orientation_diff
		eIa = e1 - e0
		e0a = e1
		e1b = beta
		eIb = e1 - e0
		e0b = e1

		run_motors(orientation_diff, beta, dist_left)

		print('dist_left ',  '   x   ',  ' y', '  current_orientation  ', 'goal_orientation','beta',)
		print("%.2f %.2f %.2f %.2f %.2f %.2f" % (dist_left,  x,  y, current_orientation, orientation_diff,beta), '\n')

	stop_motors()
	
	previous_theta = goal_orientation + previous_theta
		
if __name__ == "__main__":
	main()