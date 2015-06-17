
[X,Y] = getXY(Spect(:,:,13:29,:),cl,[1,3]);

[~,X] = pca(X,'NumComponents',2);

c = cvpartition(Y,'LeaveOut');

method = 5 ;

switch method
    case 1 %LR
        method = @LogisticRegression
    case 2 %ANN
        method = @ArtificialNeuralNetwork
    case 3 %RF
        method = @RandomForest
    case 4 %SVM
        method = @SupportVectorMachine
    case 5 %linear regression
        method = @classify
end

fun = @(xT,yT,xt,yt)(sum(yt==method(xt,xT,yT)));

%% SVM
% fun = @(xT,yT,xt,yt)(sum(yt==multisvm_hybrid(xt,xT,yT,[])));

%% linear classify
% fun = @(xT,yT,xt,yt)(sum(yt==classify(xt,xT,yT)));

%%
tic
rate = sum(crossval(fun,X,Y,'partition',c))/sum(c.TestSize)
toc