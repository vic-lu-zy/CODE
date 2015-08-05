num = [1 2 5 10 20 50 100];
dir = {[1 3], 1:3, 1:4};

fun = {'svmrbf','svmpoly','svmlin','lda','tree'};

rate = cell(7,1);

for k = 1:5
    
    switch fun{k}
        case 'svmrbf'
            t = templateSVM('Standardize',1,'KernelFunction','rbf','KernelScale','auto');
        case 'svmpoly'
            t = templateSVM('Standardize',1,'KernelFunction','polynomial');
        case 'svmlin'
            t = templateSVM('Standardize',1,'KernelFunction','linear');
        case 'lda'
            t = templateDiscriminant();
        case 'tree'
            t = templateTree();
    end
    
    rate{k} = nan(3,length(num));
    subplot(2,4,k)
    for ii = 1:3
        [X,Y,trials] = getXY(Spect,cl,dir{ii},1);
        [~,scores] = princomp(X(:,ind),'numcomponents',100);
        for jj = 1:length(num)
            rate{k}(ii,jj) = myclassify(scores(:,1:num(jj)),Y,t);
            semilogx(num,rate{k})
            drawnow
        end
    end
end
%%
rate{6} = nan(3,length(num));
dir = {[1 3], 1:3, 1:4};
subplot 246
for ii = 1:3
    [X,Y,trials] = getXY(Spect,cl,dir{ii},1);
    [~,scores] = princomp(X(:,ind),'numcomponents',100);
    for jj = 1:length(num)
        rate{6}(ii,jj) = LogisticRegression(scores(:,1:num(jj)),Y,100);
        semilogx(num,rate{6})
        drawnow
    end
end

%%
rate{7} = nan(3,length(num));
dir = {[1 3], 1:3, 1:4};
subplot 247
for ii = 1:3
    [X,Y,trials] = getXY(Spect,cl,dir{ii},1);
    [~,scores] = princomp(X(:,ind),'numcomponents',100);
    
    for jj = 1:length(num)
        rate{7}(ii,jj) = pn_classify(scores(:,1:num(jj)),Y);
        semilogx(num,rate{7})
        drawnow
    end
end