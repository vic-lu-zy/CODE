function [rate,result] = svm_classify(X,Y,numOfFeatures)

% [rate,result] = SVM_CLASSIFY(X,cl,numOfFeatures)
% rate              = correct/all (%)
% result            = predictions
% X                 = feature vectors
% Y                 = labels
% numOfFeatures     = numbers of features to use in decoding, 
%                   ranked by separability
%% crossval
c = cvpartition(size(X,1),'leaveout');
fun = @(xT,yT,xt,yt)(sum(yt==multisvm_hybrid(xt,xT,yT,numOfFeatures)));
result = crossval(fun,X,Y,'partition',c)>0;
rate = sum(result)/sum(c.TestSize);

%% for loop
% result = Y;
% % pred = zeros(length(Y),max(unique(Y)));
% m = 1:length(Y);
% for ii = m
%     result(ii) = multisvm_hybrid(X(ii,:),X(m~=ii,:),Y(m~=ii),numOfFeatures);
% end
% 
% rate = sum(result == Y)/length(Y);