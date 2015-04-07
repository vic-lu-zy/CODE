cvpart = cvpartition(Y,'holdout',0.3);
Xtrain = X(training(cvpart),:);
Ytrain = Y(training(cvpart),:);
Xtest = X(test(cvpart),:);
Ytest = Y(test(cvpart),:);

close all

%%
bag = fitensemble(Xtrain,Ytrain,'Bag',1000,'Tree',...
    'Type','Classification');
% figure;
% plot(loss(bag,Xtest,Ytest,'mode','cumulative'));
% xlabel('Number of trees');
% ylabel('Test classification error');

%%
cv = fitensemble(X,Y,'Bag',1000,'Tree',...
    'type','classification','kfold',5);
% figure;
% plot(loss(bag,Xtest,Ytest,'mode','cumulative'));
% hold on;
% plot(kfoldLoss(cv,'mode','cumulative'),'r.');
% hold off;
% xlabel('Number of trees');
% ylabel('Classification error');
% legend('Test','Cross-validation','Location','NE');

%%
figure;
plot(loss(bag,Xtest,Ytest,'mode','cumulative'));
hold on;
plot(kfoldLoss(cv,'mode','cumulative'),'r.');
plot(oobLoss(bag,'mode','cumulative'),'k--');
hold off;
xlabel('Number of trees');
ylabel('Classification error');
legend('Test','Cross-validation','Out of bag','Location','NE');