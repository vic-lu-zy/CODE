%% setup
close all
clear all
clc

EP = 46;
Fs = 1000;

load(sprintf('LFPChan%02d.mat',EP))
load('C:\Users\vic\Dropbox\thesis\data\RecordingVariables.mat', 'Eye')

parfor trial = 1:4
    f = figure(trial);
    
    x = Eye.x(trial,:);
    y = Eye.y(trial,:);
    
    X = double(LFP.AD(trial,:));
    
    [S,F,T] = spectrogram(X,2^10,2^10-1,2^12,1000);
%     S = log(abs(S));
    S = abs(S);
    len = round(T*1000);
    T = T-.999;
    
    subplot 211
    imagesc(T,F(1:200),S(1:200,:))
    axis xy
    
    subplot 212
    plot(T,x(len),T,y(len))
    axis tight
    ylim([-25 25]);
    print(f,'-dpng',sprintf('figures/Time/E%03d.png',trial))
    
    close(f)
end