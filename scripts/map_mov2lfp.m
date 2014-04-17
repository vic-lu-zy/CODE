function map_mov2lfp(trial)

load(sprintf('LFP_trial_%03d.mat',trial));
load('RecordingVariables','Eye','Hand');

tic
[S,F,T] = spectrogram(mean(LFP(33:end,:)),512,511,2^13,1000);

tl = T(1)*1000+(0:length(T)-1);

low = mean(abs(S(1:find(F>10,1),:)));
mid = mean(abs(S(find(F>20,1):find(F>40,1),:)));

d = diff(mid)-diff(low);
toc

%%
de = sqrt(diff(Eye.x(trial,:)).^2+diff(Eye.y(trial,:)).^2);
de = de>.5;

dh = sqrt(diff(Hand.x(trial,:)).^2+diff(Hand.y(trial,:)).^2);
dh = dh>.1;

% d = d < -0.002;

% subplot 211
plotyy(T(1:end-1)-1,d,T-1,[de(tl);dh(tl)])
% axis tight
% subplot 212
% plotyy(T-1,[Eye.x(trial,tl);Eye.y(trial,tl)],T-1,[Hand.x(trial,tl);Hand.y(trial,tl)])
% axis tight
