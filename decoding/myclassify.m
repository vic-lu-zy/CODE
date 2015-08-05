function [rate,preds,Mdl] = myclassify(X,Y,t)

Mdl = fitcecoc(X,Y,'Learners',t);
% CVMdl = crossval(Mdl,'leaveout','on');
CVMdl = crossval(Mdl,'kfold',10);
preds = kfoldPredict(CVMdl);
rate = mean(double(preds==Y))*100;