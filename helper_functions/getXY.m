function [X, Y] = getXY(X,cl,direction)

h = hist(cl,4);
trials = [];
n = min(h(direction));
for ii = direction
    trials = [trials; randsample(find(cl==ii),n)];
end

% random permutate the trials
ind = randperm(length(trials),length(trials));
trials = trials(ind);
%%
X = X(:,trials,:,:);
X = normalize2d(X,2);
X = permute(X,[2 1 3 4]);
% X = permute(X,[2 1 3]);
X = reshape(X,size(X,1),[]);

Y = cl(trials);
