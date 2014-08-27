function timeSeriesTuning_timeOnly(electrode,EM,f)

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

for i = 1:length(ind)
    x(i,:) = LFP.AD(ind(i),T(i)+tt);
end

%%
figure(f)
clf

for i = 1:4
    
    errorbar(tt,mean(x(cl==i,:)),std(x(cl==i,:))/sqrt(sum(cl==i)),...
        'color',colordg(i)); axis tight
    hold on
    title('time series of trials')
    xlabel('Time (ms)')
    ylabel('Voltage')

end

hold off