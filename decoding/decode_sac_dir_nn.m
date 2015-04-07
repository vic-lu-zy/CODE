ccc
load SPECT_ALL_IN_ONE
load T65sac
load cl65

%% construct feature space
% with all chan and all freq
% ind = find(~isnan(T65sac));

h = hist(cl,4);
dir = [1 2];
trials = [];
n = min(h(dir));
for ii = dir
    trials = [trials; randsample(find(cl==ii),n)];
end
%%
X = Spect{2}(:,trials,13:29,1:5:end);
% X = normalize2d(X,2);
X = permute(X,[2 1 3 4]);
% X = permute(X,[2 1 3]);
X = reshape(X,size(X,1),[]);
%%
Y = vec(repmat(dir,n,1));
% Y = label2array(Y);