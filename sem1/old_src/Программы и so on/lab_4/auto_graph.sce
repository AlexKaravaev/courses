data = read("~/datas/PID_anti_for_no_work.txt", -1, 3);
time = data(:,1) / 1000;
time = time - time(1);
distance = data(:,2)
ei = data(:,3)

kolor = 5

subplot(2,1,1)
//plot2d(time,40*ones(time),7);
plot2d(time, distance,kolor);
a = gca();
a.children.children.thickness = 2;
a.x_label.text = "$t\text{, с}$"
a.x_label.font_size = 4;
a.y_label.text = "$d\text{, см}$"
a.y_label.font_size = 4;

legend("$d_w(t)$",'$d(t)\text{ при ПД}$','$d(t)\text{ при ПИД}$','$d(t)\text{ при ПИД}+$',4)
a.children(1).font_size = 3;

subplot(2,1,2)
plot2d(time,ei,kolor)
a1 = gca();
a1.children.children.thickness = 2;
a1.x_label.text = "$t\text{, с}$"
a1.x_label.font_size = 4;
a1.y_label.text = "$U_I\text{, \%}$"
a1.y_label.font_size = 4;


legend('$U_I(t)\text{ при ПИД}$','$U_I(t)\text{ при ПИД}+$',1)
a1.children(1).font_size = 3;
