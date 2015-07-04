function [result] = multisvm_OvO(TestSet,TrainingSet,GroupTrain)

u = unique(GroupTrain);
C = nchoosek(u,2); % coeff matrix for one-to-one comparison

result = zeros(size(TestSet,1),max(u));

%% build models

models = cell(size(C,1),1);

for ii = 1:size(C,1)
    
    ind = GroupTrain==C(ii,1) | GroupTrain==C(ii,2);
    Y = GroupTrain(ind) == C(ii,1);
    X = TrainingSet(ind,:);
    models{ii} = fitcsvm(X,Y);
    
end

%% classify test cases

for j=1:size(TestSet,1)
    
    for k=1:size(C,1)
        
        pred = models{k}.predict(TestSet(j,:));
        
        if pred
            result(j,C(k,1))=result(j,C(k,1))+1;
        else
            result(j,C(k,2))=result(j,C(k,2))+1;
        end
    end
end