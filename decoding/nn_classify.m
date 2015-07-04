function yt = nn_classify(xt,xT,yT,n)

u = unique(yT);

net = patternnet(n);
thisY = yT==u(1);

net = train(net,xT',thisY');

yt = net(xt');
