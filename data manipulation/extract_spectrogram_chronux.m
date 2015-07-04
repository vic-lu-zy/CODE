function [LogBin, Spect, Axis] = extract_spectrogram_chronux(lfp,task_timing,movingwin)

params.Fs = 1000;
params.tapers = [2 3];
params.fpass = [0 500];

if nargin == 2
    movingwin = [.35 .02];
end

fspace = logspace(0,log10(500),20)';
fspace(1)=0;

ss = size(lfp);
%%
lfp = reshape(lfp,[],size(lfp,3));

[Spect,Axis.time,Axis.freq] = ...
    mtspecgramc(lfp(1,:),movingwin,params);

Axis.time = Axis.time+(task_timing(1)/1000);

[~, binidx] = histc(Axis.freq(:),fspace);
binidx(~binidx) = binidx(find(~binidx)-1);
n = max(binidx);
%% calculate pmtm
tic
Spect = single(mtspecgramc(lfp',movingwin,params));
toc

Spect = reshape(Spect,size(Spect,1),size(Spect,2),ss(1),[]);
Spect = permute(Spect,[3 4 1 2]);
%     Spect = S;

%%

ss = size(Spect);
LogBin = zeros([ss(1:3),n]);

for ii = 1:n
    if any(binidx==ii)
        LogBin(:,:,:,ii) = mean(Spect(:,:,:,binidx==ii),4);
    end
end

LogBin(:,:,:,~LogBin(1,1,1,:))=[]; % removes zero'd dimensions

