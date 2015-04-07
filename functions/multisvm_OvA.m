function [result] = multisvm_OvA(TestSet,TrainingSet,GroupTrain,numOfFeatures)

u = unique(GroupTrain);
result = zeros(size(TestSet,1),max(u));

%% build models

for ii = 1:length(u)
    
    Y = GroupTrain == u(ii);
    if isempty(numOfFeatures)
        X = TrainingSet;
    else
        reducedFeatures{ii} = rankfeatures(TrainingSet',...
            Y,'NumberOfIndices',numOfFeatures);
        X = TrainingSet(:,reducedFeatures{ii});
    end
    model{ii} = fitcsvm(X,Y);
    
end

%% classify test cases

for j=1:size(TestSet,1)
    
    for k=1:length(u)
        
        if isempty(numOfFeatures)
            result(j,u(k)) = model{k}.predict(TestSet(j,:));
        else
            result(j,u(k)) = model{k}.predict(TestSet(j,reducedFeatures{k}));
        end
        
    end
    
end