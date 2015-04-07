
params.Fs = 1000;
params.tapers = [3 5];
params.fpass = [0 60];
movingwin = [.3 .005];
[S,time,freq] = mtspecgramc(lfp(:,1),movingwin,params);
t1 = find(time>.4,1);
t2 = find(time>.7,1)-1;
f1 = find(freq>15,1);
f2 = find(freq>30,1);
%%
S = zeros(size(lfp,2),length(time),length(freq));
Pxx = zeros(size(lfp,2),length(time));
% clip = @(S) S(t1:t2,:);
for ii = 1:size(lfp,2)
    S(ii,:,:) = (mtspecgramc(lfp(:,ii),movingwin,params));
    Pxx(ii,:) = log(squeeze(mean(S(ii,:,f1:f2),3)));
end

% %%
% ss = zeros(4,length(t1:t2),31);
% for ii = 1:4
%     subplot(2,2,ii)
%     ss(ii,:,:)=log(mean(S(cl==ii,:,:)));
%     imagesc(time(t1:t2)-.5,freq,squeeze(ss(ii,:,:))')
%     axis xy
% end