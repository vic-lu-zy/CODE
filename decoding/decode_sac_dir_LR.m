function decode_sac_dir_LR
% ccc
cd '~/gs/20100407/'

% load SPECT_ALL_IN_ONE
% load cl65
% Spect = Spect{2};
load('RAW_SPECT.mat')
load('raw_cl.mat')

h = hist(cl,4);
%%
dir = [1 2 3 4];
% dir = [1 3 4];
% dir = [1 3];
n = min(h(dir));

trials = [];

for ii = dir
    trials = [trials; randsample(find(cl==ii),n)];
end

Y = vec(repmat(dir,n,1));

X = Spect(:,trials,13:29,1:20);
X = normalize2d(X,2);
% X = normalize2d(X,3);
% X = normalize2d(X,4);
X = permute(X,[2 1 3 4]);
X = reshape(X,size(X,1),[]);

%%
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
    prediction(ii) = LRpredict(theta, X(ii,:));
end

toc

%%

fileID = fopen('prediction.txt','w');
fprintf(fileID,'%1i %1i\n',[Y prediction]');
fclose(fileID);