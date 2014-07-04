function [rate,result] = lin_classify(X,cl)
c = cvpartition(size(X,1),'leaveout');
fun = @(xT,yT,xt,yt)(sum(yt==linearClassification(xt,xT,yT)));
result = crossval(fun,X,cl,'partition',c)>0;
rate = sum(result)/sum(c.TestSize);