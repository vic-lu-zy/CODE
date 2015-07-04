[X,Y] = getXY(LogBin(1,:,:,:),cl,[1,3],1);
X = normalize2d(X,2);
dims = rankfeatures(X',Y,'NumberOfIndices',20);
X = X(:,dims);
c = cvpartition(size(X,1),'leaveout');
lambdas = [0.01, 0.03, 0.05, 0.1, 0.3, 0.5, 1];
rate = lambdas;
for ii = 1:length(lambdas)
    fun = @(xT,yT,xt,yt)(sum(yt==LogisticRegression(xt,xT,yT,lambdas(ii))));
    result = crossval(fun,X,Y,'partition',c)>0;
    rate(ii) = round(sum(result)/sum(c.TestSize)*100);
end