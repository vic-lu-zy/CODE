function [successrate,result] = kernel_classify(X,cl)

K = X*X';

[~,~,V] = svd(K);

fun = @(xT,yT,xt,yt)(sum(yt==classify(xt,xT,yT)));

c = cvpartition(length(cl),'leaveout');

rate = @(i)sum(crossval(fun,K*V(:,1:i),cl,'partition',c));

result = arrayfun(rate,5:40)/sum(c.TestSize);

% plot(5:40,result)

successrate = max(result);

