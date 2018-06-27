#!/usr/bin/env python3
from ev3dev.ev3 import *
import time

mA = LargeMotor('outA')
mA.position = current_time = start_time = 0

def main():
	
	f = open ('L1_100.txt','w')

	f.write('0'+' '+'0'+'\n')

	start_time = time.time()
	
	mA.run_direct(duty_cycle_sp=-100)

	for i in range(120):
		current_time = time.time()-start_time
		motor_position = mA.position
		f.write(str(current_time) +' '+ str(motor_position)+'\n')
		time.sleep(0.01)

	mA.stop(stop_action = 'brake')

if __name__ == "__main__":
	main()