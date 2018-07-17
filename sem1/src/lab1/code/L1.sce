results=read("/home/rami/Desktop/red/ev3_course/courses/sem1/src/lab1/code/DATA/L1_100.txt",-1,2)
qlines=size(results,1)
angle=results(:,2)*%pi/180
time=results(:,1)
plot2d(time, angle, 2)
aim=[time,angle]
aim=aim'
deff('e=func(k,z)','e=z(2)-k(1)*(z(1)-k(2)*(1-exp(-z(1)/k(2))))')
att=[15;0.06]
[koeffs,errs]=datafit(func,aim,att)
Wnls = koeffs(1)
Tm = koeffs(2)
model=Wnls*(time-Tm*(1-exp(-time/Tm)))
plot2d(time,model,3)
plot2d(ang_model.time, ang_model.values, 1)

hl=legend(['Exp';'Theory';'model']);
