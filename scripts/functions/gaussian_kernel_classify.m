function successrate = gaussian_kernel_classify(X,cl)

K = gaussianKernel(X);

[~,~,V] = svd(K);

fun = @(xT,yT,xt,yt)(sum(yt==classify(xt,xT,yT)));

c = cvpartition(size(X,1),'leaveout');

rate = @(i)sum(crossval(fun,K*V(:,1:i),cl,'partition',c));

successrate = max(arrayfun(rate,30:40))/sum(c.TestSize);
