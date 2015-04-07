function I = multisvm_hybrid(TestSet,TrainingSet,GroupTrain,numOfFeatures)

% result_ova = multisvm_OvA(TestSet,TrainingSet,GroupTrain,numOfFeatures);
result_ovo = multisvm_OvO(TestSet,TrainingSet,GroupTrain,numOfFeatures);

% if sum(result_ova) == 1
%     [~,I] = max(result_ova,[],2);
%     pred = result_ova;
% else
%     I = nan;
    [~,I] = max(result_ovo,[],2);
%     pred = result_ovo;
% end