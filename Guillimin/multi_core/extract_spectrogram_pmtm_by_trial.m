function extract_spectrogram_pmtm_by_trial(cfg)
%%
% extract_spectrogram_pmtm(cfg)
% options:
%   .path
%   .task
%   .time_interval
%   .time_window
%   .time_step
%   .NFFT

%%
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

%%
trials = find(~isnan(T));
 
Axis.time = cfg.time_interval(1)+cfg.time_window/2:...
    cfg.time_step:cfg.time_interval(end)-cfg.time_window/2;
Axis.frequency = linspace(0,500,cfg.NFFT/2+1);

if ~isdir([cfg.path 'psd_by_trial_' cfg.task])
    mkdir([cfg.path 'psd_by_trial_' cfg.task])
end

save([cfg.path 'psd_by_trial_' cfg.task '/Axis'],'Axis');

%%

parfor ii = 1:length(trials)
    
    D = load([cfg.path sprintf('lfp_by_trial/LFP_trial_%03i',trials(ii))],'LFP');
    S = zeros(48,length(Axis.time),length(Axis.frequency),'single');
    for jj = 1:48
        S(jj,:,:) = lfp_spect_pmtm(D.LFP(jj,T(trials(ii))+cfg.time_interval),...
            cfg.time_window,cfg.time_step,cfg.NFFT);
    end
    parsave([cfg.path 'psd_by_trial_' cfg.task '/psd_trial_'],S,trials(ii));
    
end

% save([dir 'psd_by_trial_' cfg.task '/Spect'],'Spect');
