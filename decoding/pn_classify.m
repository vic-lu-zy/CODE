function [rate] = pn_classify(X,Y)

net = patternnet;
net.trainParam.showWindow = false;
% net.trainParam.epochs = 200;
net.divideParam.valRatio = 0.1;
net.divideParam.testRatio = 0;
net.divideParam.trainRatio = 0.9;

c = cvpartition(Y,'k',10);

fun = @(xT,yT,xt,yt)(sum(yt==pn(xt,xT,yT,net)));

rate = sum(crossval(fun,X,Y,'partition',c))/sum(c.TestSize);

end

function yt = pn(xt,xT,yT,net)
    u = unique(yT);
    Yvec = bsxfun(@eq,yT,u');
    net = train(net,xT',Yvec');
    yt = u(vec2ind(net(xt')));
end