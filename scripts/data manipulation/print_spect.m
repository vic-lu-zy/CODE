
load('C:\Users\vic\Dropbox\thesis\data\RecordingVariables.mat','Events')
samp = find(~isnan(Events.T.T65sac));
T65sac = Events.T.T65sac(samp);

f = figure(1);

for trial = 1:length(samp)
% for i = 1
    load(sprintf('lfp_trial_%03d',samp(trial)));
    x = mean(LFP(33:end,T65sac(trial)+999+(-500:1000)));
    [S,F,T] = lfp_spect_pmtm(x,257,20);
    imagesc(T-500,F,S');
    axis xy
    ylim([0 50])
    print(f,'-dpng',sprintf('figures/Spect/%03d.png',samp(trial)))
end