data = read("~/seg_data.txt",-1,6)//"/home/evgeniy/Рабочий стол/СКБ/Введение в специальность/Новое/Segway/seg_data.txt", -1, 6);
time = data(:,1) / 1000;
time = time - time(1);
kolor = 2;
subplot(3,2,1)
xtitle("Угол робота")
plot2d(time, data(:,3),kolor);
subplot(3,2,2)
xtitle("Скорость робота")
plot2d(time, data(:,2),kolor);
subplot(3,2,4)
xtitle("Скорость колес")
plot2d(time, data(:,4),kolor);
subplot(3,2,3)
xtitle("Угол колес")
plot2d(time, data(:,5),kolor);
subplot(3,2,5)
xtitle("Напряжение")
plot2d(time, data(:,6),kolor);

angle = data(:,3)
k = angle' * time / (time'*time)
disp(k)
//subplot(2,3,2)
//plot2d(time, data(:,2) - k,kolor+1);
