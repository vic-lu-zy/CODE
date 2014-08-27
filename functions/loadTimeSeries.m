function [x,tt,ex,ey] = loadTimeSeries(electrode, EM)

%% load data

load(sprintf('LFPChan%02d.mat',electrode));
load('cl_eye.mat');
load('RecordingVariables.mat')

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
[s,si]=sort(cl);
tt = -200:823;

x = zeros(length(ind),length(tt));
ex = x;
ey = x;

for i = 1:length(ind)
    x(i,:) = LFP.AD(ind(i),T(i)+tt);
    ex(i,:) = Eye.x(ind(i),T(i)+tt);
    ey(i,:) = Eye.y(ind(i),T(i)+tt);
end