function yt = LogisticRegression(xt,xT,yT,lambda)

% theta = LRClassifier(xT, yT, length(unique(yT)), lambda);
if nargin<4
    lambda = 0.1;
end

m = size(xT, 1); % number of examples
n = size(xT, 2); % how many parameters (features)

u = unique(yT);
numLabels = length(u);

initialTheta = zeros(n+1,1);
options = optimset('GradObj','on','MaxIter',150); % used in fmincg

% Add ones to the X data matrix to account for x0
xT = [ones(m, 1) xT];

% fmincg works similarly to fminunc, but is more efficient when
% dealing with large number of parameters.

if numLabels == 2
    % binary classification
    yTemp = (yT==u(1)); % select all examples of particular number for training
    theta = fmincg(@(t)(cost(t,xT,yTemp,lambda)),initialTheta,options)';
    % fmincg was taken from Andrew Ng machine learning course
else
    % multiclass one-vs-one
    theta = zeros(numLabels, n+1); % (n+1) to account for the x0 term
    tempTheta = theta';
    for i=1:numLabels
        yTemp = (yT==u(i)); % select all examples of particular number for training
        [tempTheta(:,i)] = fmincg(@(t)(cost(t,xT,yTemp,lambda)),...
            initialTheta,options);
        % fmincg was taken from Andrew Ng machine learning course
        theta(i,:) = tempTheta(:,i)';
    end
end
% yt = LRpredict(theta, xt);

m = size(xt, 1);

% Add ones to the X data matrix to account for x0
xt = [ones(m, 1) xt];

tempProb = xt * theta';

if numLabels==2
    yt = u((tempProb<0)+1);
else
    [~,I] = max(tempProb,[],2);
    yt = u(I);
end