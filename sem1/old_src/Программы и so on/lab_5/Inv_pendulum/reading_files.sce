data = read("/home/evgeniy/Рабочий стол/СКБ/Введение в специальность/Новое/Inv_pendulum/inv_pend_data.txt", -1, 6);
time = data(:,1) / 1000;
time = time - time(1);
kolor = 2;
subplot(3,2,1)
xtitle("Угол робота")
plot2d(time, data(:,3), kolor);
subplot(3,2,2)
xtitle("Скорость робота")
plot2d(time, data(:,2), kolor);
subplot(3,2,4)
xtitle("Скорость колес")
plot2d(time, data(:,4), kolor);
subplot(3,2,3)
xtitle("Угол колес")
plot2d(time, data(:,5),kolor);
subplot(3,2,5)
xtitle("Напряжение")
plot2d(time, data(:,6),kolor);
