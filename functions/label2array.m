function y = label2array(x)
[A,B] = meshgrid(unique(x),x);
y = A==B;