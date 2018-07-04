th_w = %pi;
kI = 30.0;
kP = 15;
kD = 5;
M = -0.2;
//saturation(1-yes, 0-no)
satur = 1;
maxI = 4;
importXcosDiagram("~/Рабочий стол/СКБ/Введение в специальность/Labs/Lab4/Model_of_motor_PID.zcos");
xcos_simulate(scs_m, 4)
kolor = 6;
//subplot(1,2,1)
plot2d(theta.time, theta.values*180/%pi, kolor)
//subplot(1,2,2)
//plot2d(I_part.time, I_part.values, kolor)
