function extract_spectrogram_pmtm(dir)
%

% Data = load('D:/NPL_DATA/M20140412_245/LFP_ALL_IN_ONE');

Data = load([dir 'LFP_ALL_IN_ONE']);

% ss = size(Data.LFP_ALL_IN_ONE);
% T = Data.Treach(:)+1000;
load([dir 'T65sac'])
T = repmat(T65sac,1,48)+1000;

trials = ~isnan(T(:,1));

T = reshape(T(trials,:),[],1);

LFP = reshape(Data.LFP_ALL_IN_ONE(trials,:,:),[],size(Data.LFP_ALL_IN_ONE,3));

clear Data

%%

t_int = -1000:1000;
f_samp = 257;
t_nop = 20;

%%
Axis.time = t_int(1)+ceil(f_samp/2):t_nop:t_int(end)-ceil(f_samp/2);
Axis.frequency = linspace(0,500,f_samp);
Axis.frequency = Axis.frequency(1:ceil(find(Axis.frequency>100,1)));

LFP = extract_time_range(LFP,T,t_int);
S = zeros(sum(trials),length(Axis.time),f_samp,'single');
%%

parfor ii = 1:sum(trials)*48
    S(ii,:,:) = lfp_spect_pmtm(LFP(:,ii),f_samp,t_nop);
end

Spect = reshape(S(:,:,1:length(Axis.frequency)),sum(trials),48,length(Axis.time),length(Axis.frequency));

save([dir sprintf('LFP_Spect_saccade_%03i_%03i',f_samp,t_nop)],'Spect','Axis');

