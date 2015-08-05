%% Initialize parameters
function [rateCV,rateTR] = LogisticRegression(X,Y,lambda)

% numLabels = max(Y); % number of labels
% m = size(X,1);
% trials = 1:m;
% pred = trials;
% for ii = 1:m
%     theta = LRClassifier(X(trials~=ii,:), Y(trials~=ii), numLabels, lambda);
%     [~,pred(ii)] = max(sigmoid(theta*[1 X(ii,:)]'));
% end
% rate = mean(double(pred(:) == Y)) * 100;

c = cvpartition(Y,'k',10);
% c = cvpartition(Y,'leaveout');

funCV = @(xT,yT,xt,yt)(sum(yt==LR(xt,xT,yT,lambda)));
funTR = @(xT,yT,xt,yt)(sum(yT==LR(xT,xT,yT,lambda)));

rateCV = sum(crossval(funCV,X,Y,'partition',c))/sum(c.TestSize);
rateTR = sum(crossval(funTR,X,Y,'partition',c))/sum(c.TrainSize);

end
%%
function yt = LR(xt,xT,yT,lambda)
theta = LRClassifier(xT, yT, max(yT), lambda);

u = unique(yT);
yt = sigmoid(theta*appendOnes(xt)');
if size(yt,1) == 1
    yt = sigmoid(theta*appendOnes(xt)')>.5;
    yt = u(yt+1);
else
    [~,yt] = max(yt,[],2);
end
yt = yt(:);
end