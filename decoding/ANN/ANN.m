function [rate] = ANN(X,Y,lambda)

c = cvpartition(Y,'k',10);

fun = @(xT,yT,xt,yt)(sum(yt==ann(xt,xT,yT,lambda)));

rate = sum(crossval(fun,X,Y,'partition',c))/sum(c.TestSize);

end

function yt = ann(xt,xT,yT,lambda)
    [Theta1, Theta2] = anntrain(xT,yT,lambda);
    yt = predict(Theta1, Theta2, xt);
end
