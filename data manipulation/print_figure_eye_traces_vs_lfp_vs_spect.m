function print_figure_eye_traces_vs_lfp_vs_spect(cfg)

cd(cfg.path);

if strcmp(cfg.task,'Reach')
    load([cfg.path 'Treach'])
    T = Treach+1000;
elseif strcmp(cfg.task,'Saccade')
    load([cfg.path 'T65sac'])
    T = T65sac+1000;
elseif strcmp(cfg.task,'Pursuit')
    load([cfg.path 'T66on'])
    T = T66on+1000;
end

trials = find(~isnan(T));
T = T(trials);

load([cfg.path 'psd_by_trial_' cfg.task '/Axis'])

load Eye_traces

Eye_x = extract_time_range(Eye.x(trials,:),T,cfg.time_interval);
Eye_y = extract_time_range(Eye.y(trials,:),T,cfg.time_interval);

if ~isdir([cfg.path_out cfg.task])
    mkdir([cfg.path_out cfg.task])
end

f = figure;

nFreq = find(Axis.frequency>100,1);

for ii = 1:length(trials)
    
    load(sprintf([cfg.path 'psd_by_trial_' cfg.task ...
        '/psd_trial_%03i'],trials(ii)))
    load(sprintf([cfg.path 'lfp_by_trial/LFP_trial_%03i'],...
        trials(ii)))
    
    %%
    lfp = extract_time_range(mean(LFP(1:32,:)),...
        T(ii),cfg.time_interval);
    SS = squeeze(median(S(1:32,:,2:nFreq)));
        
    subplot 311
    plot(cfg.time_interval,Eye_x(:,ii),...
        cfg.time_interval,Eye_y(:,ii)), axis tight
    title(sprintf('Trial #%03i',trials(ii)),'fontsize',30)
    ylabel('Eye Trace','fontsize',16)
    
    subplot 312
    plot(cfg.time_interval,lfp), axis tight
    ylabel('LFP time series','fontsize',16)
        
    subplot 313
    imagesc(Axis.time,Axis.frequency(2:nFreq),...
        log(SS.*repmat(2:nFreq,size(SS,1),1))'), axis xy
%     colorbar
    
    ylabel('Mean Power Spectrum','fontsize',16)
    
    xlabel('Time from onset(ms)','fontsize',16)
    
    print(f,[cfg.path_out cfg.task '/trial_' ...
        num2str(trials(ii))],'-dpng')
end
close(f)