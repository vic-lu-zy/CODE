function [result] = binarysvm(TestSet,TrainingSet,GroupTrain,kf,sig)


u = unique(GroupTrain);
assert(length(u)==2);

%build models
cl = GroupTrain == u(2);
model = svmtrain(TrainingSet,cl,'kernel_function',kf,'rbf_sigma',sig);

%classify test cases
result = zeros(size(TestSet,1));
for j=1:size(TestSet,1)
    % j-th test_inst is classified as u(2)
    result(j)=svmclassify(model,TestSet(j,:));
end

result = u(result+1);