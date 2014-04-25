function [result] = multisvm(TrainingSet,GroupTrain,TestSet,kf)
%Models a given training set with a corresponding group vector and 
%classifies a given test set using an SVM classifier according to a 
%one vs. all relation. 
%
%This code was written by Cody Neuburger cneuburg@fau.edu
%Florida Atlantic University, Florida USA
%This code was adapted and cleaned from Anand Mishra's multisvm function
%found at http://www.mathworks.com/matlabcentral/fileexchange/33170-multi-class-support-vector-machine/

u=unique(GroupTrain);
C=nchoosek(u,2); % coeff matrix for one-to-one comparison
numClasses=length(u);
result = nan(size(TestSet,1),1);

%build models
for k=1:size(C,1)
    %Vectorized statement that binarizes Group
    %where 1 is the current class and 0 is all other classes
%     G1vAll=(GroupTrain==u(k));
    ind = find(GroupTrain==C(k,1) | GroupTrain==C(k,2));
    cl  = GroupTrain(ind)==C(k,1);
    
    models(k) = svmtrain(TrainingSet(ind,:),cl,'kernel_function',kf);
    
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