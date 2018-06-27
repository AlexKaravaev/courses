#!/usr/bin/env python3
from ev3dev.ev3 import *
from math import copysign
import time

# settig up the motors and sensor
left_motor = LargeMotor('outA')
right_motor = LargeMotor('outB')
sensor_us = UltrasonicSensor('in1')

# destance measurement unit is cm
sensor_us.mode = 'US-DIST-CM'

dist_goal = 20

# proportional coeff
k_p = 1

start_time = time.time()

def main():
	data = open('data.txt', 'w')

	while True:
		dist_current = sensor_us.value() / 10
		U = k_p * (dist_goal - dist_current)

		if ( abs(U)>100 ):
			U = copysign(1, U) * 100

		print("U IS: " + str(U))

		data.write(str(time.time() - start_time) + " " + str(dist_current) + " " + str(U) )

		right_motor.run_direct(duty_cycle_sp = U)
		left_motor.run_direct(duty_cycle_sp = U)


if __name__ == '__main__':
	main()
