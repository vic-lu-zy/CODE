% function extract_spectrogram_chronux_from_raw

%%

params.Fs = 1000;
params.tapers = [2 3];
params.fpass = [0 100];
movingwin = [.3 .03];

LFP = reshape(LFP,[],size(LFP,3));

[Spect,Axis.time,Axis.frequency] = ...
    mtspecgramc(LFP(1,:),movingwin,params);

Axis.time = Axis.time-.5;
%%

Spect = zeros([size(LFP,1),size(Spect)],'single');
tic
parfor ii = 1:size(LFP,1)
    Spect(ii,:,:) = mtspecgramc(LFP(ii,:),movingwin,params);
end
toc
Spect = reshape(Spect,48,[],size(Spect,2),size(Spect,3));

%% visualization

imagesc(Axis.time,Axis.frequency,log(squeeze(mean(mean(Spect))))')
axis xy

