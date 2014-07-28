function extract_spectrogram_pmtm(cfg)

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

Data = load([cfg.path 'LFP_ALL_IN_ONE']);

if strcmp(cfg.task,'Saccade')
    load([cfg.path 'T65sac'])
    T = repmat(T65sac,1,48)+1000;
elseif strcmp(cfg.task,'Pursuit')
    load([cfg.path 'T66on'])
    T = repmat(T66on,1,48)+1000;
elseif strcmp(cfg.task,'Reach')
    load([cfg.path 'Treach'])
    T = repmat(Treach,1,48)+1000;
end

trials = ~isnan(T(:,1));

T = T(trials,:);

LFP = reshape(Data.LFP_ALL_IN_ONE(trials,:,:),[],...
    size(Data.LFP_ALL_IN_ONE,3));
LFP = extract_time_range(LFP,T(:),cfg.time_interval);

clear Data

%%
Axis.time = cfg.time_interval(1)+cfg.time_window/2:...
    cfg.time_step:cfg.time_interval(end)-cfg.time_window/2;
Axis.frequency = linspace(0,500,cfg.NFFT/2+1);
Axis.frequency = Axis.frequency(Axis.frequency<100);


%%

Spect = zeros(sum(trials)*48,length(Axis.time),cfg.NFFT/2+1,'single');

parfor ii = 1:sum(trials)*48
    Spect(ii,:,:) = lfp_spect_pmtm(LFP(:,ii),cfg);
end

Spect = reshape(Spect(:,:,1:length(Axis.frequency)),sum(trials),48,...
    length(Axis.time),length(Axis.frequency));

save([cfg.path sprintf('LFP_Spect_%s_%03i_%03i_%03i_pmtm',...
    cfg.task,cfg.time_window,cfg.time_step,cfg.NFFT)],'Spect','Axis');

end

%%
function [S,F,T] = lfp_spect_pmtm(x,options)

T = 0:options.time_step:(length(x)-options.time_window);
F = linspace(0,500,options.NFFT/2+1);

S = zeros(length(T),length(F));

for i = 1:length(T)
    S(i,:) = pmtm(x(T(i)+(1:options.time_window)),[],options.NFFT);
end

end