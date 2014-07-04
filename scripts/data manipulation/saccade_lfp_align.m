ccc

load('C:\Users\vic\Dropbox\thesis\data\lfp\LFPChan46.mat')
load RecordingVariables

%%
T = Events.T.T65sac;

%%
lfp = LFP.AD;
T = nan(size(lfp,1),1);

for i = 1:size(lfp,1)
    if any(lfp(i,:)>0.9)
        T(i) = find(lfp(i,:)>0.9,1);
        if T(i) > 10000
            T(i) = nan;
        end
    end
end

T = T-1000;
%%
I = find(~isnan(T)); % index of saccade
T = T(I)+1000; % start time of saccade

n = length(T);
t = -200:600;

lfp65 = zeros(n,length(t));
% y65 = x65;


for i = 1:length(T)
    lfp65(i,:) = LFP.AD(I(i),t+T(i));
end

subplot 211
plot(Eye.T/1000,LFP.AD(I,:)'); axis tight
title('pre-alignment x')
xlabel('time (s)')

subplot 212
plot(t/1000,lfp65'); axis tight
title('post alignment x')
xlabel('time (s)')
