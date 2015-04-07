function decode_sac_dir

% cd '~/gs/20100412/'
load SPECT_ALL_IN_ONE
Spect = Spect{2};
load cl65

%% construct feature space
% with all chan and all freq

h = hist(cl,4);
%%
dir = [1 2 3 4];
% dir = [1 3 4];
% dir = [1 3];
n = min(h(dir));
% trials = 1:size(Spect,2);
% Y = cl;
% Y = cl(randperm(length(cl)));
% n = 10;
trials = [];
for ii = dir
    trials = [trials; randsample(find(cl==ii),n)];
end

Y = vec(repmat(dir,n,1));

% rate = zeros(48,1);

% for ii = 1:48

X = Spect(:,trials,13:29,:);
X = normalize2d(X,2);
% X = normalize2d(X,3);
% X = normalize2d(X,4);
X = permute(X,[2 1 3 4]);
X = reshape(X,size(X,1),[]);

clear Spect

%%
rate = zeros(500,1);
filename = 'rate.txt';
fileID = fopen(filename,'w');
fclose(fileID);

for ii = 1:500
	rate(ii) = svm_classify(X,Y,ii);
%     fopen(filename,'a');
%     fprintf(fileID,'%04i %5.3f\n',[ii,rate]);
%     fclose(fileID);
end
%%
% tic
%     rate(ii) = svm_classify(X,Y,100);
% end

% bar(rate)
% n = (10:50)*10;
% r = nan(length(n),1);
% for ii = 1:length(n)
%     [r(ii),result] = svm_classify(X,Y,n(ii));
%     plot(n,r)
%     drawnow
% end
% toc