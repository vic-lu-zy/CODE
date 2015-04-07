function [low mid] = filtLowMid(x)

x = double(x);

% subplot 311 
% plot(x)

[b,a] = butter(9,10/500);
low = filtfilt(b,a,x);

% subplot 312
% plot(low)

[b,a] = butter(9,20/500,'high');
mid = filtfilt(b,a,x);
[b,a] = butter(9,40/500);
mid = filtfilt(b,a,mid);

% subplot 313
% plot(mid)