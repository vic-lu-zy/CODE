ccc

load('C:\Users\vic\Dropbox\thesis\data\RecordingVariables.mat','Events')

%%
T65 = Events.T.T65sac;
samp65 = find(~isnan(T65));
T65 = Events.T.T65sac(samp65)+1000;
n65 = length(T65);

lfp = zeros(length(T65),48,500);

w = waitbar(0);
for trial = 1:n65
    waitbar(trial/n65,w);
    load(sprintf('lfp_trial_%03d',samp65(trial)));
    lfp(trial,:,:) = LFP(:,T65(trial)+(1:500));
end
close(w)

%%

T66 = Events.T.T66on;
samp66 = find(~isnan(T66));
T66 = Events.T.T66on(samp66)+1000;
n66 = length(T66);

lfp = zeros(length(T66),48,500);

w = waitbar(0);
for trial = 1:n66
    waitbar(trial/n66,w);
    load(sprintf('lfp_trial_%03d',samp66(trial)));
    lfp(trial,:,:) = LFP(:,T66(trial)+(1:500));
end
close(w)
