function extract_spectrogram_pmtm

load('D:/NPL_DATA/M20140412_245/Treach');
Data = load('D:/NPL_DATA/M20140412_245/LFP_ALL_IN_ONE');

ss = size(Data.LFP_ALL_IN_ONE);

LFP = reshape(Data.LFP_ALL_IN_ONE,[],ss(3));
Treach = Data.Treach(:)+1000;

clear Data

%%

t_int = -1000:1000;
f_samp = 513;
t_nop = 20;

Axis.time = t_int(1)+ceil(f_samp/2):t_nop:t_int(end)-ceil(f_samp/2);
Axis.frequency = 1:f_samp/5;
save('D:/NPL_DATA/M20140412_245/Axis','Axis');

LFP = extract_time_range(LFP,Treach,t_int);
S = zeros(length(Treach),length(Axis.time),f_samp);
%%
parfor ii = 1:ss(1)*ss(2)
        S(ii,:,:) = lfp_spect_pmtm(LFP(:,ii),f_samp,t_nop);
end
S = reshape(S(:,:,Axis.frequency+1),ss(1),ss(2),size(S,2),size(S,3));
save('D:/NPL_DATA/M20140412_245/LFP_Spect_hand_movement','S');