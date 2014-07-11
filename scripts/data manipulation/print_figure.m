load('Axis.mat')
load('trials')

f = figure(1);
freq = find(Axis.frequency < 100);

% trials = 1:413;

% w = waitbar(0);
for i = 1:length(trials)
    load(sprintf('psd_trial_%03i',trials(i)))
    subplot(211)
    imagesc(Axis.time(1:5:end),Axis.frequency(freq),...
        squeeze(mean(abs(S(1:32,freq,1:5:end)))))
    axis xy
    title(sprintf('Spectogram of Saccade trial #%03i',trials(i)),'fontsize',18)
    ylabel('Frequency (Hz)','fontsize',14)
    colorbar
    
    subplot(212)
    imagesc(Axis.time(1:5:end),Axis.frequency(freq),...
        diff(squeeze(mean(abs(S(1:32,freq,1:5:end))))))
    axis xy
    title(sprintf('Slope-Spectogram of Saccade trial #%03i',trials(i)),'fontsize',18)
    colorbar
    xlabel('Time w.r.t. onset (ms)','fontsize',14)
    ylabel('Frequency (Hz)','fontsize',14)
    print(f,sprintf('C:/Users/vic/Google Drive/Thesis/Saccade_Spectrum/Trial_%03i',trials(i)),'-dpng')
    %     waitbar(i/length(trials),w)
end
% close(w)
