function [X, Y] = getXY(X,cl,dir)

h = hist(cl,4);
trials = [];
n = min(h(dir));
for ii = dir
    trials = [trials; randsample(find(cl==ii),n)];
end
%%
X = X(:,trials,:,:);
X = normalize2d(X,2);
X = permute(X,[2 1 3 4]);
% X = permute(X,[2 1 3]);
X = reshape(X,size(X,1),[]);

Y = cl(trials);
