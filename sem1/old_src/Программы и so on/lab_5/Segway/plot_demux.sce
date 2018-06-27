kolor = 3
importXcosDiagram("/home/evgeniy/Рабочий стол/СКБ/Введение в специальность/Новое/Segway/cart_3_clss_demux.zcos");
xcos_simulate(scs_m, 4);

subplot(3,2,1);
xtitle("Угол Segway");
plot2d(psi.time, 180/%pi*psi.values,[kolor]);
subplot(3,2,3);
xtitle("Угол колес");
plot2d(theta.time, 180/%pi*theta.values,[kolor]);
subplot(3,2,2);
xtitle("Скорость падения");
plot2d(dpsi.time, 180/%pi*dpsi.values,[kolor]);
subplot(3,2,5);
xtitle("Напряжение в В");
plot2d(volt.time, volt.values,[kolor]);
subplot(3,2,4);
xtitle("Скорость колес");
plot2d(dtheta.time, 180/%pi*dtheta.values,[kolor]);
