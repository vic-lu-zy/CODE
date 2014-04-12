%% setup
close all
clear all
clc

trial = 150;
EP = 46;
Fs = 1000;

load(sprintf('LFPChan%02d.mat',EP))
load('C:\Users\vic\Dropbox\thesis\data\RecordingVariables.mat', 'Eye')

x = Eye.x(trial,:);
% x(x>10)=nan;
X = double(LFP.AD(trial,:));

[S,F,T] = spectrogram(X,2^10,2^10-1,2^12,1000);
S = abs(S);
ss = squeeze(mean(reshape(S(1:200,:),10,[],size(S,2))));
len = length(x)+(-length(T)+1:0);
%% display
% 
% len = 1:200;
% 
% figure(1)
% 
% subplot 411
% imagesc(T,F(len),S(len,:))
% axis xy
% 
% subplot 412
% plot(T,S(30,:));
% title(sprintf('Freq = %5.2f Hz',F(30)));
% axis tight
% 
% subplot 413
% plot(T,S(100,:));
% axis tight
% title(sprintf('Freq = %5.2f Hz',F(100)));
% 
% subplot 414
% plot(T,S(200,:));
% axis tight
% title(sprintf('Freq = %5.2f Hz',F(200)));

%% compare against eye

figure(2)
subplot 211
plot(S(1:200,5000:6000)');
axis tight
subplot 212
plot(x(5000:6000));
axis tight