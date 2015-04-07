net = feedforwardnet;
x = ez(1:30:end);
net = train(net,x,S);
y = net(x);
plotregression(S,y,'Regression')
