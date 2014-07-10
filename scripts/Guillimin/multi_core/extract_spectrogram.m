function extract_spectrogram

% dir = 'S:\NPL_DATA\M20140412_245\';
cd ~

dir = '~/gs/';
%
% load([dir 'T65sac'])
% T = T65sac+1000;
%
load([dir 'Treach'])
T = Treach+1000;

trials = find(~isnan(T));

%%

t_int = -500:500;
window = 64;
noverlap = 1;
NFFT = 256;

Axis.time = t_int(1)+window/2:noverlap:t_int(end)+1-window/2;
Axis.frequency = linspace(0,500,NFFT/2+1);

save([dir 'psd_by_electrode_reach/Axis'],'Axis');
% save([dir 'psd_by_electrode_saccade/Axis'],'Axis');

%%

for ii = 18:48
    D = load([dir sprintf('lfp_by_electrode/LFPChan%02i',ii)],'LFP');
    LFP = extract_time_range(D.LFP.AD(trials,:),T(trials),t_int);
    S = zeros(length(trials),length(Axis.frequency),length(Axis.time));
    parfor jj = 1:length(trials)
        S(jj,:,:) = spectrogram(LFP(:,jj),window,window-noverlap,NFFT);
    end
    save([dir sprintf('psd_by_electrode_reach/LFPChan%02i',ii)],'S');
%     save([dir sprintf('psd_by_electrode_saccade/LFPChan%02i',ii)],'S');
    
end
