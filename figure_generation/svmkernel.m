%% rbf
figure(1)
subplot 231
svmtrain(scores(:,[1 3]),Y,'kernel_function','rbf','rbf_sigma',.1,'showplot',true);
title('\sigma = 0.1','fontsize',18)
ylabel('Linearly Separable','fontsize',18)
legend off
subplot 232
svmtrain(scores(:,[1 3]),Y,'kernel_function','rbf','rbf_sigma',1,'showplot',true);
title('\sigma = 1.0','fontsize',18)
legend off
subplot 233
svmtrain(scores(:,[1 3]),Y,'kernel_function','rbf','rbf_sigma',10,'showplot',true);
title('\sigma = 10','fontsize',18)
legend off
subplot 234
svmtrain(scores(:,[2 3]),Y,'kernel_function','rbf','rbf_sigma',.1,'showplot',true);
ylabel('Non Linearly Separable','fontsize',18)
legend off
subplot 235
svmtrain(scores(:,[2 3]),Y,'kernel_function','rbf','rbf_sigma',1,'showplot',true);
title('SVM with RBF kernel','fontsize',20)
legend off
subplot 236
svmtrain(scores(:,[2 3]),char((Y==1)*'R'+(Y==2)*'L'),'kernel_function','rbf','rbf_sigma',10,'showplot',true);

%% poly
figure(2)
subplot 231
svmtrain(scores(:,[1 3]),Y,'kernel_function','polynomial','polyorder',1,'showplot',true);
title('degree = 1','fontsize',18)
ylabel('Linearly Separable','fontsize',18)
legend off
subplot 232
svmtrain(scores(:,[1 3]),Y,'kernel_function','polynomial','polyorder',3,'showplot',true);
title('degree = 3','fontsize',18)
legend off
subplot 233
svmtrain(scores(:,[1 3]),Y,'kernel_function','polynomial','polyorder',5,'showplot',true);
title('degree = 5','fontsize',18)
legend off
subplot 234
svmtrain(scores(:,[2 3]),Y,'kernel_function','polynomial','polyorder',1,'showplot',true);
ylabel('Non Linearly Separable','fontsize',18)
legend off
subplot 235
svmtrain(scores(:,[2 3]),Y,'kernel_function','polynomial','polyorder',3,'showplot',true);
title('SVM with Polynomial kernel','fontsize',20)
legend off
subplot 236
svmtrain(scores(:,[2 3]),Y,'kernel_function','polynomial','polyorder',5,'showplot',true);
legend off
xlabel('All Units = PCA scores','fontsize',18)