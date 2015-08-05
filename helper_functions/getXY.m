function [X, Y, trials] = getXY(X,cl,direction,redist)

if redist
    h = hist(cl,4);
    trials = [];
    n = min(h(direction));
%     n = min(floor(120/length(direction)),n);
    for ii = direction
        trials = [trials; randsample(find(cl==ii),n)];
    end
else
    trials = sum(bsxfun(@eq,cl,direction),2)>0;
end

%%
X = X(:,trials,:,:);
X = permute(X,[2 1 3 4]);
% X = permute(X,[2 1 3]);
X = reshape(X,size(X,1),[]);
X = single(X);
X = normalize2d(X,1);
Y = cl(trials);
