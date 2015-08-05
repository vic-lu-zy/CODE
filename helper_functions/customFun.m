function rate = customFun(B,FitInfo,X,Ybool,indx)

B0 = B(:,indx);
cnst = FitInfo.Intercept(indx);
% B1 = [cnst;B0];
preds = X*B0>-cnst;
plot(preds,'o')

cp = classperf(Ybool,preds); 

rate = cp.CorrectRate;