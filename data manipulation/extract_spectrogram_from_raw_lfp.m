params.Fs = 1000;
params.tapers = [2 3];
params.fpass = [0 100];
movingwin = [.3 .03];

[Spect,Axis.time,Axis.frequency] = ...
    mtspecgramc(-500:1000,movingwin,params);

Axis.time = Axis.time - .5;

Spect = zeros([48,length(T),size(Spect)]);

tic
w = waitbar(0);
for ii = 1:48
    L = load(sprintf('D:/NPL_DATA/M20100407_456/lfp_by_channel/LFPChan%02i',ii),'LFP');
    LFP = L.LFP.rawData.ad;
    for jj = 1:length(T)
        Spect(ii,jj,:,:) = mtspecgramc( ...
            LFP(T(jj)+(-500:1000)), movingwin, params);
    end
    waitbar(ii/48,w)
end
close(w)
toc