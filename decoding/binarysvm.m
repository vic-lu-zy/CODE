function [result] = binarysvm(TestSet,TrainingSet,GroupTrain)


% u = unique(GroupTrain);
% assert(length(u)==2);
% 
% %build models
% cl = GroupTrain == u(2);
model = fitcsvm(TrainingSet,GroupTrain);

%classify test cases
% result = zeros(size(TestSet,1),1);
% for j=1:size(TestSet,1)
%     % j-th test_inst is classified as u(2)
%     result(j)=model.predict(TestSet(j,:));
% end

result = model.predict(TestSet);

% result = u(result+1);