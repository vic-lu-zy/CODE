load('D:\NPL_DATA\M20100407_456\Variables\LFPxeye.mat')
raw.x = LFP.rawData.ad;
raw.x(raw.x> -min(raw.x)) = nan;
load('D:\NPL_DATA\M20100407_456\Variables\LFPyeye.mat')
raw.y = LFP.rawData.ad;
raw.y(raw.y< -max(raw.y)) = nan;
% raw.t = LFP.rawData.T;
load('D:\NPL_DATA\M20100407_456\lfp_by_channel\LFPChan01.mat', 'LFP')
% raw.lfp = LFP.rawData.ad;
%% eliminate off screen gazes
% [Nx,Xx] = hist(raw.x, 100);
% [Ny,Xy] = hist(raw.y, 100);
% 
% % figure;
% % subplot(2,1,1);
% % bar(Xx, Nx);
% % subplot(2,1,2);
% % bar(Xy, Ny);
% 
% x_max = Xx(end-4); % within 95 percentile
% x_min = Xx(5);
% 
% y_max = Xy(end-4);
% y_min = Xy(5);
% 
% goodPointsMask = raw.x > x_min & raw.x < x_max & raw.y > y_min & raw.y < y_max;
% 
% raw.x = interp1(sampleTime(goodPointsMask), raw.x(goodPointsMask), sampleTime,'nearest','extrap');
% raw.y = interp1(sampleTime(goodPointsMask), raw.y(goodPointsMask), sampleTime,'nearest','extrap');

%%
step = 5;
t = 1:step:length(raw.x)-150;
[xx,yy] = meshgrid(t,0:149);
n = xx+yy; 
clear xx yy
x = raw.x(n);
y = raw.y(n);
% t = raw.t(n);
% LFP = raw.lfp(n);

%%
n = zeros(length(n),1);
% w = waitbar(0);
tic
for ii = 1:length(n)
    n(ii) = findDirection(x(:,ii),y(:,ii));
%     waitbar(ii/length(n),w)
end
toc
% close(w)

%%
x = x(:,~isnan(n));
y = y(:,~isnan(n));

% LFP = LFP(:,~isnan(n));
t = t(~isnan(n));
n = n(~isnan(n));

%%
ind = find(diff(t)==step)+1;
x(:,ind) = [];
y(:,ind) = [];
% LFP(:,ind) = [];
t(ind) = [];
n(ind) = [];

%%
x = x - repmat(x(1,:),size(x,1),1);
y = y - repmat(y(1,:),size(y,1),1);
z = abs(x+1i*y);
z = z./repmat(z(end,:),size(z,1),1);
ft = fittype('piecewiseLine(x,x1,x2)');
tic
T = arrayfun(@(i)align_sac(z(:,i),ft),1:length(z)) + t;
toc
%%
for ii = 1:length(T)
x(:,ii) = (raw.x(T(ii)+(-50:99)));
y(:,ii) = (raw.y(T(ii)+(-50:99)));
% LFP(:,ii) = (raw.lfp(T(ii)+(-50:99)));
end

ind = (any(isnan(y) | isnan(x)));
x(:,ind)=[];
y(:,ind)=[];
% LFP(:,ind)=[];
T(ind)=[];
n(ind)=[];
t(ind)=[];