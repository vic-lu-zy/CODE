function extract_spectrogram_pmtm
%

% Data = load('D:/NPL_DATA/M20140412_245/LFP_ALL_IN_ONE');
dir = '~/gs/';
% dir = 'S:\NPL_DATA\M20140412_245\';

Data = load([dir 'LFP_ALL_IN_ONE']);

% T = Data.Treach+1000;
load([dir 'T65sac'])
T = repmat(T65sac,1,48)+1000;

trials = ~isnan(T(:,1));
% T = T(:);
T = reshape(T(trials,:),[],1);

LFP = reshape(Data.LFP_ALL_IN_ONE(trials,:,:),[],...
    size(Data.LFP_ALL_IN_ONE,3));

clear Data

%%

t_int = -500:500;
window = 50;
t_nop = 5;
nfft = 512;

%%
Axis.time = t_int(1)+window/2:t_nop:t_int(end)-window/2;
Axis.frequency = linspace(0,500,nfft/2+1);
Axis.frequency = Axis.frequency(Axis.frequency<100);

LFP = extract_time_range(LFP,T,t_int);
Spect = zeros(sum(trials)*48,length(Axis.time),nfft/2+1,'single');
%%

parfor ii = 1:sum(trials)*48
    Spect(ii,:,:) = lfp_spect_pmtm(LFP(:,ii),window,t_nop,nfft);
end

Spect = reshape(Spect(:,:,1:length(Axis.frequency)),sum(trials),48,length(Axis.time),length(Axis.frequency));

%%
save([dir sprintf('LFP_Spect_saccade_%03i_%03i',window,t_nop)],'Spect','Axis');

