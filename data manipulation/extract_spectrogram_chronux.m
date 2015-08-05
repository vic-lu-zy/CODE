function [Spect, Axis] = ...
    extract_spectrogram_chronux(lfp,task_timing,movingwin,tapers)

params.Fs = 1000;
params.tapers = tapers;
params.fpass = [0 100];

ss = size(lfp);
%%
lfp = reshape(lfp,[],size(lfp,3));

[~,Axis.time,Axis.freq] = ...
    mtspecgramc(lfp(1,:),movingwin,params);

Axis.time = Axis.time'+(task_timing(1)/1000);

%% calculate pmtm
Spect = single(mtspecgramc(lfp',movingwin,params));

Spect = reshape(Spect,size(Spect,1),size(Spect,2),ss(1),[]);
Spect = permute(Spect,[3 4 1 2]);
