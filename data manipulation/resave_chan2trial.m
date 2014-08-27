% cd 'D:\NPL_DATA\M20140412_245';
% 
% cd ~/gs/
%% Create LFP_ALL_IN_ONE
LFP_ALL_IN_ONE = zeros(48,432,11501,'single');

for ii = 1:48
    load(sprintf('LFPChan%02i',ii));
    LFP_ALL_IN_ONE(ii,:,:) = LFP.AD;
end
LFP_ALL_IN_ONE = permute(LFP_ALL_IN_ONE,[2 1 3]);

%% Save LFP by trials
for ii = 1:size(LFP_ALL_IN_ONE,1)
    LFP = squeeze(LFP_ALL_IN_ONE(ii,:,:));
    save(sprintf('D:/NPL_DATA/M20100407_456/lfp_by_trial/LFP_trial_%03i',ii),'LFP');
end