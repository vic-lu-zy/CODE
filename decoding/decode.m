clc

trials = (cl==1 | cl==3);

X = SpectBinned{2}(17,trials,13:29,:);
X = permute(X,[2 1 3 4]);
X = reshape(X,size(X,1),[]);
Y = cl(trials);

methods = {'SVM','KNN','LDA','Trees'};

for method = 1:4
    switch method
        case 1
            t = templateSVM('Standardize',1);
        case 2
            t = templateKNN('Standardize',1);
        case 3
            t = templateDiscriminant();
        case 4
            t = templateTree();
        case 5
%             t = templateNaiveBayes(); %too long !!
    end
    
    fprintf('Processing %5s, it took ... ',methods{method})
    Mdl = fitcecoc(X,Y,'Learners',t);
    tic
    CVMdl = crossval(Mdl,'leaveout','on');
    rate(method) = 1-kfoldLoss(CVMdl);
    time(method) = toc;
    fprintf('%5.2f s, with a rate of %5.2f.\n',time(method),rate(method))
end
%%

subplot 121
bar(1:4,1-rate)
set(gca,'XTickLabel',methods);
subplot 122
bar(1:4,time)
set(gca,'XTickLabel',methods);
