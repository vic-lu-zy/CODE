% function extract_spectrogram_chronux

%%
% to_do = [2 3 4 5]; %2 = sac, 3 = pur, 4 = fix, 5 = reach
to_do = 2

params.Fs = 1000;
params.tapers = [2 3];
params.fpass = [0 500];
movingwin = [.5 .01];
% 
% dir = '';
% % dir = 'D:/NPL_DATA/M20100412_245/';
% % dir = pwd;
% 
% %%
% 
% Data_lfp = load([dir 'LFP_ALL_IN_ONE']);
% if exist('SPECT_ALL_IN_ONE.mat','file')
%     Data_spect = load([dir 'SPECT_ALL_IN_ONE']);
% end
%%

for task = to_do
    
    lfp = LFP{task};
    
    lfp = reshape(lfp,[],size(lfp,3));
    
    [~,Axis{task}.time,Axis{task}.frequency] = ...
        mtspecgramc(lfp(1,:),movingwin,params);
    
    Axis{task}.time = Axis{task}.time+(task_timing{task}(1)/1000);
    %%
    tic
    S = single(mtspecgramc(lfp',movingwin,params));
    toc
    S = reshape(S,size(S,1),size(S,2),48,[]);
    Spect{task} = permute(S,[3 4 1 2]);
    
end
% Spect = Data_spect.Spect;
% Axis = Data_spect.Axis;
% save([dir 'SPECT_ALL_IN_ONE'],'Spect','Axis');