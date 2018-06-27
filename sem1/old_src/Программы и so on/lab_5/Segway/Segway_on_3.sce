Umax = 7.380            //управляющее напряжение
mw = 0.015;             //масса колеса
ms = 0.519 - 2*mw       //масса всей конструкции
mm = 0.081;             //масса низа (двигателя)
mg = 0.015;             //масса гироскопа
mc = ms - 2*mm - mg;    //масса кирпича со всеми крепежными деталями
dg = 0.023;             //глубина гироскопа
hg = 0.042;             //высота гироскопа
lg = 0.10;              //расстояние между центрами масс Segway и гироскопа
dc = 0.045;             //глубина "кирпича"
hc = 0.11;              //высота кирпича
lc = 0.01;              //расстояние между центрами масс Segway и кирпича
dm = 0.04;             //глубина низа
hm = 0.09;             //высота низа.
lm = 0.035;              //расстояние между центрами масс Segway и низа
g = 9.82;               //ускорение свободного падения
l = 0.08;//0.13;               //расстояние от колес до центра масс
R = 8.0;                  //сопротивление двигателя
r = 0.043/2;              //радиус колеса
km = 0.5;             //одноименные конструктивные постоянные
ke = 0.5;
J = 0.0023;

//Вычисляемые величины
Jw = mw*r^2/2;   //момент инерции колеса
Jg0 = mg*(dg*dg + hg*hg)/12; //момент инерции гироскопа относительно его центра масс
Jg = Jg0 + mg*lg^2;//момент инерции гироскопа относительно центра масс Segway
Jm0 = mm*(dm*dm + hm*hm)/12; //момент инерции сервомотора относительно центра масс его параллелепипеда.
Jm = Jm0 + mm*lm^2;//момент инерции мотора относительно центра масс всей конструкции
Jc0 = mc*(dc*dc + hc*hc)/12; //момент инерции относительно его центра масс
Jc = Jc0 + mc*lc^2;//момент инерции кирпича относительно центра масс всей конструкции
Js = Jc + Jg + 2*Jm;  //момент инерции segway (J одн. стержень отн. его центра)
//Js = 0.0025;

time = 0.6;     //Время переходного процесса
p=poly(0,"p");  //просто символ 
w0 = 6.3/time;  //Параметр w0
cp = (p+w0)^3;  //Желаемый характеристический полином


E = {ms*l*r - 2*J,  Js + ms*l^2;
     2*mw*r^2 + ms*r^2 + 2*Jw + 2*J, ms*r*l};

F = { -2*km*ke/R, 0;
     2*km*ke/R,  0};

G = {0, -ms*g*l;
     0, 0};

H = { -2*km/R;  
     2*km/R};

EG = (E^-1)*G;
EF = (E^-1)*F; 
EH = (E^-1)*H;
EG = (-1)*EG;
EF = (-1)*EF;

A = {   0,       0,       1; //матрица, определяющая динамические свойства Segway
     EG(1,2), EF(1,1), EF(1,2);
     EG(2,2), EF(2,1), EF(2,2)}
B = {  0;                        //матрица входа управляющих воздействий
    EH(1,1); 
    EH(2,1)};

    
Y = [B, A*B, A^2*B];             //матрица управляемости

if rank(Y) == 3 then
    printf("\nIt can be controlled\n\n");
end
if rank(Y) <> 3 then
    printf("\nIt can not be controlled\n\n");
end

C=eye(3,3);       //матрица выхода

Q={  C;                           //матрица наблюдаемости
    C*A;
   C*A^2};

if rank(Q) == 3 then
    printf("It is observable\n");
end
if rank(Q) <> 3 then
    printf("It is not observable\n");
end

coeffs = coeff(cp);
K = [0, 0, 1] * Y^-1 * (coeffs(1) * eye(3,3) + coeffs(2) * A + coeffs(3) * A^2 + A^3);


disp(A);
disp(B);
printf("\nYou need: ");
disp(cp);
printf("\nYou will have: ");
disp(det(p*eye(3,3)-(A-B*K)));
printf("Where coeffs:\n");
disp(K)
printf("For program:\n");
disp(K*%pi/180);
printf("Fifth coeff (for program):\n");
kd = -A(2,2)/B(2);
L  = kd;
disp(-A(2,2)/B(2)*%pi/180);
disp(-A(3,2)/B(3)*%pi/180)
//help_matr = -C*(A-B*K)^(-1)*B;
//disp(help_matr);
//kg = 1 / help_matr(2);
//printf("\nkg = %f\nbut for program:\nkg = %f", kg, kg*%pi/180);

//Для структурной схемы
//начальные условия
psi0 = %pi/20;     //начальный угол
dpsi0 = 0.1;      //начальная скорость падения
dtheta0 = 0.5;    //начальная скорость колес
theta0 = 0;     //начальный угол поворота колес

//Остальное
k1 = K(1);
k2 = K(2);
k3 = K(3);
//kd = 0
a22 = A(2,2);
a21 = A(2,1);
b2 = B(2);
a32 = A(3,2);
a31 = A(3,1);
b3 = B(3);

kp = ( 3*w0^2 + A(3,1)) / B(3);
ki = (w0^3 + (A(3,2)*A(2,1)-A(2,2)*A(3,1)))/B(3);
kd = ( 3*w0 + A(2,2)) / B(3);
disp(%pi/180*[kp, ki, kd])

w = 1
kolor = 5
importXcosDiagram("/home/evgeniy/Рабочий стол/СКБ/Введение в специальность/Новое/Segway/cart_3.zcos");
xcos_simulate(scs_m, 4);
subplot(3,2,1);
xtitle("Угол Segway");
plot2d(psi.time, 180/%pi*psi.values,[kolor]);
subplot(3,2,3);
xtitle("Угол колес");
plot2d(dtheta.time, 180/%pi*theta.values,[kolor]);
subplot(3,2,2);
xtitle("Скорость падения");
plot2d(dpsi.time, 180/%pi*dpsi.values,[kolor]);
subplot(3,2,5);
xtitle("Напряжение в В");
plot2d(napr.time, napr.values,[kolor]);
subplot(3,2,4);
xtitle("Скорость колес");
plot2d(dpsi.time, 180/%pi*dtheta.values,[kolor]);

 

