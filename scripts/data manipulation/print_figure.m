clear all

% load LFP_Spect_pursuit_050_005_512_pmtm
% load T66on
load T65sac
load Axis
load('RecordingVariables.mat', 'Eye')

trials = find(~isnan(T65sac));
% trials = 1:413;

f = figure(1);

Eye_x = extract_time_range(Eye.x(~isnan(T65sac),:),...
    T65sac(~isnan(T65sac))+1000,Axis.time);
Eye_y = extract_time_range(Eye.y(~isnan(T65sac),:),...
    T65sac(~isnan(T65sac))+1000,Axis.time);

clear Eye
%%

% w = waitbar(0);
for i = 1:length(trials)
    %%
    load(sprintf('psd_trial_%03i',trials(i)))
    S = squeeze(median(S(1:32,:,:)))';
    S = S(2:ceil(end/5),:).*repmat((2:ceil(size(S,1)/5))',1,size(S,2));
    figure(f)
    subplot 211
    imagesc(Axis.time,Axis.frequency(2:ceil(end/5)),S);
    title(sprintf('Spectogram of Saccade trial #%03i',trials(i)),...
        'fontsize',18)
    ylabel('Frequency (Hz)','fontsize',14)
    axis xy
%     subplot 211
%     plot(Axis.time,mean(S))
%     axis tight
%     title('Average Power of 0~100 Hz','fontsize',18)
    subplot 212
    [ax,h1,h2] = plotyy(Axis.time,[Eye_x(:,i),Eye_y(:,i)],Axis.time,mean(S));
    set(ax(1),'ylim',[-16,16])
    set(h1,'linewidth',2)
    set(h2,'linewidth',2)
%     axis tight
    title('Position of Eyes vs. Average Power of 0~100 Hz','fontsize',18)
    xlabel('Time w.r.t. onset (ms)','fontsize',14)
    print(f,sprintf('C:/Users/vic/Google Drive/Thesis/Saccade_Spectrum/Trial_%03i',trials(i)),'-dpng')
%     waitbar(i/length(trials),w)
end
% close(w)
