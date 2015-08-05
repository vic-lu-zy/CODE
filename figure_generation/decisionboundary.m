clf
x1 = X(:,1);
x2 = X(:,2);
x1range = linspace(min(x1),max(x1),1e3);
x2range = linspace(min(x2),max(x2),1e3);
[xx1,xx2] = meshgrid(x1range,x2range);

%% ANN 0.1
[Theta1, Theta2] = anntrain(X,Y,.1);
ss = predict(Theta1, Theta2, [xx1(:),xx2(:)]);
ss = reshape(ss,sqrt(numel(ss)),[]);

subplot 231

imagesc(x1range,x2range,ss)
colormap([1 0.8 0.8; 0.8 0.8 1]);

hold on

h1 = gscatter(x1,x2,Y,'rb','ov',[],'off');
h1(1).LineWidth = 2;
h1(2).LineWidth = 2;
legend('0^o','180^o')
xlabel('Feature #1'), ylabel('Feature #2')
axis tight square

title('ANN','fontsize',20)

%% ANN
[Theta1, Theta2] = anntrain(X,Y,1);
ss = predict(Theta1, Theta2, [xx1(:),xx2(:)]);
ss = reshape(ss,sqrt(numel(ss)),[]);

subplot 232

contour(x1range,x2range,ss)
% colormap([1 0.8 0.8; 0.8 0.8 1]);

hold on

h1 = gscatter(x1,x2,Y,'rb','ov',[],'off');
h1(1).LineWidth = 2;
h1(2).LineWidth = 2;
legend('0^o','180^o')
xlabel('Feature #1'), ylabel('Feature #2')
axis tight square

title('ANN','fontsize',20)

%% ANN
[Theta1, Theta2] = anntrain(X,Y,10);
ss = predict(Theta1, Theta2, [xx1(:),xx2(:)]);
ss = reshape(ss,sqrt(numel(ss)),[]);

subplot 233

contour(x1range,x2range,ss)
% colormap([1 0.8 0.8; 0.8 0.8 1]);

hold on

h1 = gscatter(x1,x2,Y,'rb','ov',[],'off');
h1(1).LineWidth = 2;
h1(2).LineWidth = 2;
legend('0^o','180^o')
xlabel('Feature #1'), ylabel('Feature #2')
axis tight square

title('ANN','fontsize',20)

%% LR
B = mnrfit([x1,x2],(Y==1)+1);

ss = glmval(B,[xx1(:) xx2(:)],'logit');
ss = reshape(ss,sqrt(numel(ss)),[]);

subplot 234

imagesc(x1range,x2range,ss)
colormap([1 0.8 0.8; 0.8 0.8 1]);

hold on

h1 = gscatter(x1,x2,Y,'rb','ov',[],'off');
h1(1).LineWidth = 2;
h1(2).LineWidth = 2;
legend('0^o','180^o')
xlabel('Feature #1'), ylabel('Feature #2')
axis tight square

title('Logit Reg','fontsize',20)

%% SVM
cls = fitcsvm([x1,x2],Y,'Standardize',true,'KernelFunction','RBF',...
    'KernelScale','auto');

ss = cls.predict([xx1(:) xx2(:)]);
ss = reshape(ss,sqrt(numel(ss)),[]);

subplot 235

imagesc(x1range,x2range,ss)
colormap([1 0.8 0.8; 0.8 0.8 1]);

hold on

h1 = gscatter(x1,x2,Y,'rb','ov',[],'off');
h1(1).LineWidth = 2;
h1(2).LineWidth = 2;
legend('0^o','180^o')
xlabel('Feature #1'), ylabel('Feature #2')
axis tight square

title('SVM RBF Kernel','fontsize',20)

%% SVM
cls = fitcsvm([x1,x2],Y,'Standardize',true,'KernelFunction','Polynomial');

ss = cls.predict([xx1(:) xx2(:)]);
ss = reshape(ss,sqrt(numel(ss)),[]);

subplot 236

imagesc(x1range,x2range,ss)
colormap([1 0.8 0.8; 0.8 0.8 1]);

hold on

h1 = gscatter(x1,x2,Y,'rb','ov',[],'off');
h1(1).LineWidth = 2;
h1(2).LineWidth = 2;
legend('0^o','180^o')
xlabel('Feature #1'), ylabel('Feature #2')
axis tight square

title('SVM Polynomial Kernel','fontsize',20)