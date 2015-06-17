
[X,Y] = getXY(Spect(:,:,13:29,:),cl,[1,3]);

[~,X] = pca(X,'NumComponents',10);

c = cvpartition(Y,'LeaveOut');

%% LR
% fun = @(xT,yT,xt,yt)(sum(yt==LR(xt,xT,yT,0.1)));

%% SVM
fun = @(xT,yT,xt,yt)(sum(yt==multisvm_hybrid(xt,xT,yT,[])));

%% linear classify
% fun = @(xT,yT,xt,yt)(sum(yt==classify(xt,xT,yT)));

%%
tic
rate = sum(crossval(fun,X,Y,'partition',c))/sum(c.TestSize)
toc