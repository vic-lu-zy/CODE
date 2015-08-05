function [err] = thisLR(X,Y,lambda)

c = cvpartition(Y,'k',10);
if (length(unique(Y))) == 2
    Yvec = Y==Y(1);
else
    Yvec = bsxfun(@eq,Y,unique(Y)');
end
%%
err = [0 0];
for ii = 1:c.NumTestSets
    theta = LRClassifier(X(c.training(ii),:), ...
        Y(c.training(ii)), length(unique(Y)), lambda);
    err = err + [norm(Yvec(c.training(ii),:)-...
        (sigmoid(theta*appendOnes(X(c.training(ii),:))'))'),...
        norm(Yvec(c.test(ii),:)-...
        (sigmoid(theta*appendOnes(X(c.test(ii),:))'))')]/c.NumTestSets;
end
