kolor = 5
importXcosDiagram("/home/evgeniy/Рабочий стол/СКБ/Введение в специальность/Новое/Segway/cart_3_clss.zcos");
xcos_simulate(scs_m, 4);

subplot(3,2,1);
xtitle("Угол Segway");
plot2d(outp.time, 180/%pi*outp.values(:,1),[kolor]);
//subplot(3,2,3);
//xtitle("Угол колес");
//plot2d(dtheta.time, 180/%pi*theta.values,[kolor]);
subplot(3,2,2);
xtitle("Скорость падения");
plot2d(outp.time, 180/%pi*outp.values(:,3),[kolor]);
subplot(3,2,5);
xtitle("Напряжение в В");
plot2d(outp.time, volt.values,[kolor]);
subplot(3,2,4);
xtitle("Скорость колес");
plot2d(outp.time, 180/%pi*outp.values(:,2),[kolor]);
