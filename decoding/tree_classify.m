function [rate,result] = tree_classify(X,Y)

t = templateTree();
Mdl = fitcecoc(X,Y,'Learners',t);
CVMdl = crossval(Mdl,'leaveout','on');
result = kfoldPredict(CVMdl);
rate = sum(result==Y)/length(Y);