ccc

load('C:\Users\vic\Dropbox\thesis\data\RecordingVariables.mat','Events')

T = Events.T.T65sac;

samp = find(~isnan(T));

T = Events.T.T6(samp);

%%
lfp = zeros(length(T),48,1500);

for trial = 1:length(samp)
    load(sprintf('lfp_trial_%03d',samp(trial)));
    lfp(trial,:,:) = LFP(:,T(trial)+999+(0:1499));
end