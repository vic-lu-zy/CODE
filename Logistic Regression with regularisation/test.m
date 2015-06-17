%% Initialize parameters

m = size(X, 1); % number of examples
lambda = 0.1;
u = unique(Y);
numLabels = size(u,1); % number of labels

%%

% ind = [];
% for jj = 1:numLabels
%     ind = [ind rankfeatures(X',...
%         (Y==u(jj)),'NumberOfIndices',50)];
% end

%%

prediction = zeros(m,1);
tic
% for kk = 1:length(lambda)
parfor ii = 1:m
    ind = (1:m ~= ii);
    thisX = X(ind,:);
    thisY = Y(ind);
    theta = LRClassifier(thisX, thisY, numLabels, lambda);
    prediction(ii) = predict(theta, X(ii,:));
end
%%
toc