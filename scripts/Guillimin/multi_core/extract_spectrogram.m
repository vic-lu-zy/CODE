function extract_spectrogram
%

% dir = '~/gs/';

dir = 'S:\NPL_DATA\M20140412_245\';

% 
% f = fopen('~/debugging.txt','w');
% 
% fwrite(f,[dir '\n']);
% fwrite(f,[pwd '\n']);

% cd(dir);

% Data = load('D:/NPL_DATA/M20140412_245/LFP_ALL_IN_ONE');

Data = load([dir 'LFP_ALL_IN_ONE']);

% ss = size(Data.LFP_ALL_IN_ONE);
% T = Data.Treach(:)+1000;
load([dir 'T65sac'])
T = repmat(T65sac,1,48)+1000;

% fwrite(f,'1\n');

trials = ~isnan(T(:,1));

T = reshape(T(trials,:),[],1);

LFP = reshape(Data.LFP_ALL_IN_ONE(trials,:,:),[],...
    size(Data.LFP_ALL_IN_ONE,3));

clear Data

% fwrite(f,'2\n');
%%

t_int = -200:200;
window = 64;
noverlap = 2;
NFFT = 256;

LFP = extract_time_range(LFP,T,t_int);

%%

% fwrite(f,'3\n');
[S, Axis.frequency, Axis.time] = ...
    spectrogram(LFP(:,1),window,window-noverlap,NFFT,1000);

Axis.frequency = Axis.frequency(1:ceil(find(Axis.frequency>100,1)));
Axis.time = Axis.time + t_int(1)/1000;
S = zeros([sum(trials)*48,size(S)]);
% fwrite(f,'4\n');
w = waitbar(0);
for ii = 1:sum(trials)*48
    S(ii,:,:) = spectrogram(LFP(:,ii),window,window-noverlap,NFFT);
    waitbar(ii/sum(trials)/48,w);
end
close(w)
% fwrite(f,'5\n');
Spect = single(reshape(S(:,1:length(Axis.frequency),:),sum(trials),...
    48,length(Axis.frequency),length(Axis.time)));

save([dir sprintf('LFP_Spect_saccade_%03i_%03i',window,noverlap)],...
    'Spect','Axis');
% fwrite(f,'6\n');
% fclose(f);
