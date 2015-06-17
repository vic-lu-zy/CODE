function y = myPiecewise(x,t1,t2)

m = 1/(t2-t1);
b = -m*t1;
y = m*x+b;

y(x<t1)=0;
y(x>t2)=1;