function [rate,result] = svm_classify(X,Y,numOfFeatures) %,kf,sig)

% [rate,result] = SVM_CLASSIFY(X,cl,kf,sig)
% rate      = correct/all (%)
% result    = predictions
% X         = feature vectors
% cl        = labels
% kf        = kernel functions : {linear,rbf,...}
% sig       = sigma of rbf

% c = cvpartition(size(X,1),'leaveout');
% % c = cvpartition(size(X,1),'kfold');
% fun = @(xT,yT,xt,yt)(sum(yt==multisvm_hybrid(xt,xT,yT,numOfFeatures))); %,kf,sig)));
% % fun = @(xT,yT,xt,yt)(sum(yt==binarysvm(xt,xT,yT,kf,sig)));
% result = crossval(fun,X,Y,'partition',c)>0;
% rate = sum(result)/sum(c.TestSize);

result = Y;
% pred = zeros(length(Y),max(unique(Y)));

for ii = 1:length(Y)
    xTesting = X(ii,:);
%     yTesting = Y(ii);
    k = [1:ii-1 ii+1:length(Y)];
    xTraining = X(k,:);
    yTraining = Y(k);
    
    result(ii) = multisvm_DAG(xTesting,xTraining,yTraining,numOfFeatures);
end

rate = sum(result == Y)/length(Y);