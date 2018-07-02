results=read("/home/rami/Desktop/red/ev3_course/courses/sem1/src/lab3/code/data.txt",-1,2)
qlines=size(results,1)
dist=results(:,2)
time=results(:,1)/1000
plot2d(time, dist, 1)
