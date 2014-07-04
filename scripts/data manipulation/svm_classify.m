function [rate,result] = svm_classify(X,cl,kf,sig)
c = cvpartition(size(X,1),'leaveout');
fun = @(xT,yT,xt,yt)(sum(yt==multisvm(xt,xT,yT,kf,sig)));
result = crossval(fun,X,cl,'partition',c)>0;
rate = sum(result)/sum(c.TestSize);