ccc

load fisheriris
X = meas;
Y = species;

%%
oosLoss = zeros(100,5);
w = waitbar(0);
for itr = 1:100
    for method = 1:5
        switch method
            case 1
                t = templateSVM();
            case 2
                t = templateKNN();
            case 3
                t = templateNaiveBayes();
            case 4
                t = templateDiscriminant();
            case 5
                t = templateTree();
        end
        
        %%
        Mdl = fitcecoc(X,Y,'Learners',t,...
            'ClassNames',{'setosa','versicolor','virginica'});
        
        %%
        CVMdl = crossval(Mdl);
        
        oosLoss(itr,method) = kfoldLoss(CVMdl);
    end
    waitbar(itr/100,w)
end
close(w)
%% plotting
errorbar(1:5,mean(oosLoss),std(oosLoss),'linewidth',4)
grid on
methods = {'SVM','KNN','NaiveBayes','Discriminant','Trees'};
set(gca,'XTick',1:5,'XTickLabel',methods)
yticks = get(gca,'YTick');
if all(yticks<1)
    set(gca,'YTickLabel',sprintf('%03.1f%%\n',yticks*100))
end