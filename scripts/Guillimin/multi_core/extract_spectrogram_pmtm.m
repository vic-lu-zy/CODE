function extract_spectrogram_pmtm(cfg)

%%
% extract_spectrogram_pmtm(dir,task,options)
% options:
%   .path
%   .task
%   .time_interval
%   .time_window
%   .time_step
%   .NFFT

%%
dir = cfg.path;
task = cfg.task;

Data = load([dir 'LFP_ALL_IN_ONE']);

if strcmp(task,'Saccade')
    load([dir 'T65sac'])
    T = repmat(T65sac,1,48)+1000;
elseif strcmp(task,'Pursuit')
    load([dir 'T66on'])
    T = repmat(T66on,1,48)+1000;
elseif strcmp(task,'Reach')
    load([dir 'Treach'])
    T = repmat(Treach,1,48)+1000;
end

trials = ~isnan(T);

T = T(trials);

LFP = reshape(Data.LFP_ALL_IN_ONE(trials,:,:),[],...
    size(Data.LFP_ALL_IN_ONE,3));

clear Data

%%
Axis.time = cfg.time_interval(1)+cfg.time_window/2:...
    cfg.time_step:cfg.time_interval(end)-cfg.time_window/2;
Axis.frequency = linspace(0,500,cfg.NFFT/2+1);
Axis.frequency = Axis.frequency(Axis.frequency<100);

LFP = extract_time_range(LFP,T,cfg.time_interval);

%%

Spect = zeros(sum(trials)*48,length(Axis.time),cfg.NFFT/2+1,'single');

parfor ii = 1:sum(trials)*48
    Spect(ii,:,:) = lfp_spect_pmtm(LFP(:,ii),cfg);
end

Spect = reshape(Spect(:,:,1:length(Axis.frequency)),sum(trials),48,...
    length(Axis.time),length(Axis.frequency));

save([dir sprintf('LFP_Spect_%s_%03i_%03i_%03i_pmtm',...
    task,cfg.time_window,cfg.time_step,cfg.NFFT)],'Spect','Axis');

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