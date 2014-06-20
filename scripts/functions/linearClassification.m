% linear classification


function [cl_val] = linearClassification(X_val,X_train, cl_train)

[C, ~, D] = unique(cl_train);

%this transforms the class number vector into a matrix of binary coded
%class numbers

%note that it is very important that if there are N classes the classes are
%numbered from 1:N. they can't be sparse.
t_train = zeros(size(X_train,1),length(C));
for i = 1:size(X_train,1)
    t_train(i, D(i)) = 1;
end

%%
%augment the input with ones
X_train = [ones(size(X_train,1),1), X_train];


%%

W = linearRegressionParameters(X_train, t_train);


%%

X_val = [ones(size(X_val,1),1), X_val];

y_val = X_val*W;

[~, tmp1a] = max(y_val,[],2);

cl_val = C(tmp1a)';

cl_val = cl_val';

end




