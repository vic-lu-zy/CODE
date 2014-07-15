ccc

load('LFP_Spect_hand_257_020_pmtm.mat')
trials = 1:413;

f = figure(1);

%%

w = waitbar(0);
for i = 1:length(trials)
    S = squeeze(median(Spect(i,1:32,:,:)))';
    figure(f)
    imagesc(Axis.time,Axis.frequency(2:26),...
        S(2:26,:).*repmat(log(2:26)',1,88));axis xy
    
    title(sprintf('Spectogram of Reach trial #%03i',trials(i)),'fontsize',18)
    ylabel('Frequency (Hz)','fontsize',14)
    xlabel('Time w.r.t. onset (ms)','fontsize',14)
    print(f,sprintf('C:/Users/vic/Google Drive/Thesis/Reach_Spectrum/Trial_%03i',trials(i)),'-dpng')
    waitbar(i/length(trials),w)
end
close(w)
