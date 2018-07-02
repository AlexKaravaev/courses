from ev3dev.ev3 import *
import time
import math

# defining motors,sensors and some constants
mA = LargeMotor('outA')
mB = LargeMotor('outB')
mA.position = mB.position = cur_time = start_time = 0
us1 = UltrasonicSensor('in1')
us2 = UltrasonicSensor('in2')

# put sensors into distance mode
us1.mode = 'US-DIST-CM'
us2.mode = 'US-DIST-CM'

dist_wanted = 40

# dist between sensors
H = 23

# koeficients
K_p = 3

fwd_V = -70

def main():
    f = open('data.txt', 'w')

    # using try finally to close file even if exc will be raised
    try:
        # last integral err
        e_i = 0
        last_time = start_time = time.time()
        # value is returned = mm, convert it to cm
        d1 = us1.value() / 10
        d2 = us1.value() / 10
        distance = (d1 + d2) * H * math.sqrt(1.0 / (H * H + (d2 - d1) * (d2 - d1))) / 2.0
        last_e = dist_wanted - distance

        while True:
            d1 = us1.value() / 10
            d2 = us2.value() / 10

            dt = (time.time() - last_time) / 1000
            last_time = time.time()

            distance = (d1 + d2) * H * math.sqrt(1.0 / (H * H + (d2 - d1) * (d2 - d1))) / 2.0

            # calculate errors
            e = dist_wanted - distance

            # calculate U
            u_rot = K_p * e
            if (abs(u_rot) > (100 - abs(fwd_V))):
                u_rot = math.copysign(1,u_rot) * (100 - abs(fwd_V))

            u_left = fwd_V + u_rot
            u_right = fwd_V - u_rot

            mA.run_direct(duty_cycle_sp = u_left)
            mB.run_direct(duty_cycle_sp = u_right)

            f.write(str(time.time() - start_time) + " " + str(distance) + " " + str(e_i))


    finally:
        mA.stop(stop_action = 'brake')
        mB.stop(stop_action = 'brake')
        f.close()

if __name__ == '__main__':
    main()
