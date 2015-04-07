function [result] = multisvm(TestSet,TrainingSet,GroupTrain) %,kf,sig)

u = unique(GroupTrain);
C = nchoosek(u,2); % coeff matrix for one-to-one comparison
result = nan(size(TestSet,1),1);
% pred = zeros(size(TestSet,1),length(u));
%% build models

for ii = 1:size(C,1)
    ind = GroupTrain==C(ii,1) | GroupTrain==C(ii,2);
    Y = GroupTrain(ind) == C(ii,1);
    reducedFeatures{ii} = rankfeatures(TrainingSet(ind,:)',...
        Y,'NumberOfIndices',50);
    X = TrainingSet(ind,reducedFeatures{ii});
    model{ii} = fitcsvm(X,Y);
    
end

%% classify test cases
temp = zeros(max(C(:)),1);

for j=1:size(TestSet,1)
    
    for k=1:size(C,1)
        %         if(svmclassify(models(k),TestSet(j,:)))
        if model{k}.predict(TestSet(j,reducedFeatures{ii}))
            temp(C(k,1))=temp(C(k,1))+1;
        else
            temp(C(k,2))=temp(C(k,2))+1;
        end
    end
%     if sum(temp==max(temp))>1
%         keyboard
%     end
    [~,result(j)]=max(temp);
end