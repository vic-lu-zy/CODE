cvpart = cvpartition(Y,'holdout',0.3);
Xtrain = X(training(cvpart),:);
Ytrain = Y(training(cvpart),:);
Xtest = X(test(cvpart),:);
Ytest = Y(test(cvpart),:);

%%
% r = zeros(10,1);
tic
nTree = 10;
% parfor nTree = 1:10
%     for n = 1:100
        bag = TreeBagger(nTree*10,Xtrain,Ytrain,'Method','Classification');
%         r(nTree) = r(nTree)+
        sum(Ytest==str2double(predict(bag,Xtest)))/length(Ytest)
%     end
% end
toc
%%
% r = zeros(100,1);
% for n = 1:100
%     bag = TreeBagger(200,Xtrain,Ytrain,'Method','Classification');
%     r(n) = sum(Ytest==str2double(predict(bag,Xtest)))/length(Ytest);
% end