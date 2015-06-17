function yt = LogisticRegression(xt,xT,yT,lambda)

% theta = LRClassifier(xT, yT, length(unique(yT)), lambda);

m = size(xT, 1); % number of examples
n = size(xT, 2); % how many parameters (features)

u = unique(yT);
numLabels = length(u);

theta = zeros(numLabels, n+1); % (n+1) to account for the x0 term
initialTheta = zeros(n+1,1);
options = optimset('GradObj','on','MaxIter',150); % used in fmincg

% Add ones to the X data matrix to account for x0
xT = [ones(m, 1) xT];

% fmincg works similarly to fminunc, but is more efficient when 
% dealing with large number of parameters.

tempTheta = theta';

for i=1:numLabels
    yTemp = (yT==i); % select all examples of particular number for training
    [tempTheta(:,i)] = fmincg(@(t)(cost(t,xT,yTemp,lambda)),...
                               initialTheta,options);
    % fmincg was taken from Andrew Ng machine learning course
    theta(i,:) = tempTheta(:,i)';
end

% yt = LRpredict(theta, xt);

m = size(xt, 1);

% Add ones to the X data matrix to account for x0
xt = [ones(m, 1) xt];

tempProb = xt * theta';
[~,I] = max(tempProb,[],2);
yt = u(I);