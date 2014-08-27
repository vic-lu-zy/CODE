function extract_spectrogram(task)

cd ~
% dir = 'D:/NPL_DATA/M20140412_245/';
dir = '~/gs/';

if strcmp(task,'Reach')
    load([dir 'Treach'])
    T = Treach+1000;
elseif strcmp(task,'Saccade')
    load([dir 'T65sac'])
    T = T65sac+1000;
end

trials = find(~isnan(T));

%%

t_int = -500:500;
window = 64;
noverlap = 1;
NFFT = 256;

Axis.time = t_int(1)+window/2:noverlap:t_int(end)+1-window/2;
Axis.frequency = linspace(0,500,NFFT/2+1);

save([dir 'psd_by_trial_' task '/Axis'],'Axis');

%%

parfor ii = 1:length(trials)
    D = load([dir sprintf('lfp_by_trial/LFP_trial_%03i',trials(ii))],'LFP');
    S = zeros(48,length(Axis.frequency),length(Axis.time),'single');
    for jj = 1:48
        S(jj,:,:) = spectrogram(D.LFP(jj,T(trials(ii))+t_int),...
            window,window-noverlap,NFFT);
    end
    parsave([dir 'psd_by_trial_' task '/psd_trial_'],S,trials(ii));
    
end
