function extract_spectrogram_chronux

%%

params.Fs = 1000;
params.tapers = [2 3];
params.fpass = [0 50];
movingwin = [.3 .03];

% dir = '~/gs/20100412/';
dir = 'D:/NPL_DATA/M20100412_245/';

%%

Data = load([dir 'LFP_ALL_IN_ONE']);

LFP = reshape(Data.LFP_ALL_IN_ONE,[],size(Data.LFP_ALL_IN_ONE,3));

clear Data

%%

[Spect,Axis.time,Axis.frequency] = mtspecgramc(LFP(1,:),movingwin,params);

%%

Spect = zeros([size(LFP,1),size(Spect)],'single');

parfor ii = 1:size(LFP,1)
    Spect(ii,:,:) = mtspecgramc(LFP(ii,:),movingwin,params);
end

Spect = reshape(Spect,48,[],size(Spect,2),size(Spect,3));

save([dir 'SPECT_ALL_IN_ONE'],'Spect','Axis');

end