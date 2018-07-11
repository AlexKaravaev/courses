results=read("/home/rami/Desktop/angle.txt",-1,2)
qlines=size(results,1)
dist=results(:,2)
time=results(:,1)/1000
plot2d(time, dist, 1)
