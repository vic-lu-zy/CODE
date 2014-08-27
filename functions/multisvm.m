function [result] = multisvm(TestSet,TrainingSet,GroupTrain,kf,sig)

u=unique(GroupTrain);
C=nchoosek(u,2); % coeff matrix for one-to-one comparison
numClasses=length(u);
result = nan(size(TestSet,1),1);

%build models
for k=1:size(C,1)
    ind = find(GroupTrain==C(k,1) | GroupTrain==C(k,2));
    cl  = GroupTrain(ind)==C(k,1);
    models(k) = svmtrain(TrainingSet(ind,:),cl,...
        'kernel_function',kf,'rbf_sigma',sig);
end

%classify test cases
for j=1:size(TestSet,1)
    temp = zeros(max(C(:)),1);
    for k=1:size(C,1)
        if(svmclassify(models(k),TestSet(j,:)))
            temp(C(k,1))=temp(C(k,1))+1;
        else
            temp(C(k,2))=temp(C(k,2))+1;
        end
    end
    [~,result(j)]=max(temp);
end