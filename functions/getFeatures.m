function [preFk, durFk, posFk,ff] = getFeatures(electrode,eye)

% pursuit #66
% saccade #65


load(['D:\Documents\Dropbox\thesis/data/lfp/LFPChan' num2str(electrode) '.mat']);
load(['D:\Documents\Dropbox\thesis/data/cl' num2str(eye) '.mat']);
[s,ind] = sort(cl);

switch(eye)
    case 65
        load('T65sac.mat');
        T = T65sac+1000;
    case 66
        load('T66on.mat');
        T = T66on+1000;
    case 8
        load('T8.mat');
        T = T8;
    case 666
        load('T65sac.mat');
        load('T66on.mat');
        load('T8.mat');
        T = T8;
        T(~isnan(T65sac))= T65sac(~isnan(T65sac));
        T(~isnan(T66on)) = T66on(~isnan(T66on));
end

I = find(~isnan(T));

%%
% T6 = Events.strobeTimes((J-1)*size(Events.strobeTimes,1)+I);
T = T(I);

len = (-256:0);
t1 = -300+len;
t2 = 128+len;
t3 = 1000+len;

%%
nTrial = length(T);

% time domain
pre = zeros(nTrial,257);
dur = pre;
pos = pre;

% freq domain
preF = pre;
durF = pre;
posF = pre;

% extract time windows
for i = 1:nTrial
    pre(i,:) = LFP.AD(I(i),T(i)+t1);
    dur(i,:) = LFP.AD(I(i),T(i)+t2);
    pos(i,:) = LFP.AD(I(i),T(i)+t3);
end

% freq transform
w = waitbar(0,'Calculating PMTM');
tic
for i = 1:nTrial
    waitbar(i/nTrial,w,sprintf('%4.2f %%',i/nTrial*100));
    preF(i,:) = pmtm(pre(i,:));
    durF(i,:) = pmtm(dur(i,:));
    posF(i,:) = pmtm(pos(i,:));
end
% [~,ff]=pmtm(pre(1,:));
toc
close(w)

% separate into freq bins of 5 Hz
preFk = zeros(nTrial,8);
durFk = preFk;
posFk = preFk;

for i = 1:nTrial
    for j = 1:8
        preFk(i,j) = mean(preF(i,(j-1)*3+(1:3)),2);
        durFk(i,j) = mean(durF(i,(j-1)*3+(1:3)),2);
        posFk(i,j) = mean(posF(i,(j-1)*3+(1:3)),2);
    end
end
%%
% ff is normalized from 0 to pi. To recover freq, do: ff * fs / (2 pi)
ff = (1:8)*3*500/257;
subplot 411
imagesc(1:length(T),ff,preFk(ind,:)')
title('Pre')
axis xy
subplot 412
imagesc(1:length(T),ff,durFk(ind,:)')
title('During')
ylabel('Freq (Hz)')
axis xy
subplot 413
imagesc(1:length(T),ff,posFk(ind,:)')
title('Post')
axis xy

xlabel('Trial Number')

subplot 414
plot(s)