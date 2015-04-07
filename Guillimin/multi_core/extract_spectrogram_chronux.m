function extract_spectrogram_chronux

%%
to_do = [2 3 4 5]; %2 = sac, 3 = pur, 4 = fix, 5 = reach

params.Fs = 1000;
params.tapers = [2 3];
params.fpass = [0 100];
movingwin = [.5 .01];

dir = '';
% dir = 'D:/NPL_DATA/M20100412_245/';
% dir = pwd;

%%

Data_lfp = load([dir 'LFP_ALL_IN_ONE']);
if exist('SPECT_ALL_IN_ONE.mat','file')
    Data_spect = load([dir 'SPECT_ALL_IN_ONE']);
end
%%

for task = to_do
    
    LFP = Data_lfp.LFP{task};
    
    LFP = reshape(LFP,[],size(LFP,3));
    
    [S,Data_spect.Axis{task}.time,Data_spect.Axis{task}.frequency] = ...
        mtspecgramc(LFP(1,:),movingwin,params);
    
    Data_spect.Axis{task}.time = Data_spect.Axis{task}.time+(Data_lfp.task_timing{task}(1)/1000);
    %%
    
    S = zeros([size(LFP,1),size(S)],'single');
    tic
    parfor ii = 1:size(LFP,1)
        S(ii,:,:) = mtspecgramc(LFP(ii,:),movingwin,params);
    end
    toc
    Data_spect.Spect{task} = reshape(S,48,[],size(S,2),size(S,3));
    
end
Spect = Data_spect.Spect;
Axis = Data_spect.Axis;
save([dir 'SPECT_ALL_IN_ONE'],'Spect','Axis');