if ~exist('Spect','var')
    load SPECT_ALL_IN_ONE
    Spect = Spect{2};
    Axis = Axis{2};
end

%% construct feature space
% with all chan and all freq
n_onset = find(Axis.time>0,1)-2;

F_before = Spect(1:32,:,n_onset+(0:9)-10,1:2:end);
cl = ones(size(F_before,2),1);
cl(end+1:end*2) = 2;
%%
r = zeros(30,1);
% w = waitbar(0);
parfor k = -9:20
    
    F_after  = Spect(1:32,:,n_onset+(0:9)+k,1:2:end);
    
    X = [F_before F_after];
    X = permute(X,[2 1 3 4]);
    X = reshape(X,size(X,1),[]);
    
    %%
    r(k+10) = svm_classify(X,cl,'linear',[]);%,10^(ii-4))
%     waitbar((k+11)/30,w)
end
% close(w)
plot(-9:20,r)