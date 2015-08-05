function [err] = thisANN(X,Y,lambda)

c = cvpartition(Y,'k',10);
u = unique(Y);

Yvec = bsxfun(@eq,Y,u');

numlabel = length(u);
%%
err = [0 0];
for ii = 1:c.NumTestSets
    
    [Theta1, Theta2] = anntrain(X(c.training(ii),:),...
        Y(c.training(ii)),lambda);
    
    h1 = sigmoid(appendOnes(X(c.training(ii),:)) * Theta1');
    ytrain = sigmoid(appendOnes(h1) * Theta2');
    
    h1 = sigmoid(appendOnes(X(c.test(ii),:)) * Theta1');
    ytest = sigmoid(appendOnes(h1) * Theta2');
    
    err = err + [norm(Yvec(c.training(ii),:)-ytrain),...
        norm(Yvec(c.test(ii),:)-ytest)]...
        ./sqrt([c.TrainSize(ii), c.TestSize(ii)]/numlabel);
end
err = err/c.NumTestSets;