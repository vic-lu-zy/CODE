function timeSeriesTuning(electrode,EM)

%% load data

if electrode < 1 || electrode > 48
    error('no such electode')
elseif electrode < 10
    load(['LFPChan0' num2str(electrode) '.mat']);
else
    load(['LFPChan' num2str(electrode) '.mat']);
end

load('cl_eye.mat');
load('RecordingVariables.mat')

% load('D:\Documents\Dropbox\thesis\data\cl_hand.mat');

switch(EM)
    case 65
        load('T65sac.mat');
        T = T65sac-LFP.T(1);
        
    case 66
        load('T66on.mat');
        T = T66on-LFP.T(1);
        
    case 8
        load('T8.mat');
        T = T8;
        
end

ind = find(~isnan(T));
T = T(ind);
cl = cl(ind);

tt = -200:600;

x = zeros(length(ind),length(tt));
ex = x;
ey = x;

% [b a] = butter(9,.05);

for i = 1:length(ind)
    x(i,:) = LFP.AD(ind(i),T(i)+tt);
    ex(i,:) = Eye.x(ind(i),T(i)+tt);
    ey(i,:) = Eye.y(ind(i),T(i)+tt);
end

% x = filtfilt(b,a,x')';

%%
figure

for i = 1:4
    
    subplot 311
    errorbar(tt,mean(x(cl==i,:)),std(x(cl==i,:))/sqrt(sum(cl==i)),...
        'color',colordg(i)); axis tight
%     plot(tt,mean(x(cl==i,:)),'color',colordg(i)); axis tight
    hold on
    title('time series of saccade trials')
    xlabel('Time (ms)')
    ylabel('Voltage')
    
    subplot 312
    plot(tt,ex(cl==i,:),'color',colordg(i));
    axis tight
    hold on
    title('X - Dir')
    ylabel('Dist (cm)')
    xlabel('Time (ms)')
    grid on
    
    subplot 313
    plot(tt,ey(cl==i,:),'color',colordg(i));
    axis tight
    hold on
    title('Y - Dir')
    ylabel('Dist (cm)')
    xlabel('Time (ms)')
    grid on
end