if ~exist('Spect','var')
    load SPECT_ALL_IN_ONE
    Spect = Spect{2};
    Axis = Axis{2};
end

%% construct feature space
% with all chan and all freq
n_onset = find(Axis{2}.time>0,1)-2;

step = -10:5:20;
X = [];
cl = [];
for ii = 1:length(step)
    X = [X Spect{2}(1:32,:,n_onset+(0:9)+step(ii),1:2:end)];
    cl = [cl; ones(size(Spect{2},2),1)*ii];
end
%%
r = zeros(length(step),1);
% w = waitbar(0);
X = permute(X,[2 1 3 4]);
X = reshape(X,size(X,1),[]);

%%
tic;
r = svm_classify(X,cl,'linear',[]);%,10^(ii-4))
toc
%     waitbar((k+11)/30,w)
% end
% close(w)
% plot(-9:20,r)