ccc
load SPECT_ALL_IN_ONE
load T65sac

%% construct feature space
% with all chan and all freq
ind = find(~isnan(T65sac));
F_presac = Spect{2}(1:32,randsample(177,58),1:10,1:2:end);
F_fixation = Spect{4}(1:32,:,21:30,1:2:end);

cl = ones(58,1);
cl(59:2*58) = 2;

X = [F_presac F_fixation];
X = permute(X,[2 1 3 4]);
X = reshape(X,size(X,1),[]);

%%
clc
r = svm_classify(X,cl,'linear',[]);
% l = logspace(-1.19,-1.1,10);
% r = l;
% for ii = 1:10
%     r(ii) = svm_classify(X,cl,'rbf',l(ii));
% end
r
% sprintf('%5.2f%% error of telling pre-saccade LFP from fixation LFP',(1-r)*100)