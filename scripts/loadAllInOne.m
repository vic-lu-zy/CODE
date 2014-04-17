%%

choice = questdlg('Are you sure?', ...
    'Load All LFP', ...
    'Yes','No','No');
% Handle response
if strcmp(choice , 'Yes')
    
    for i = 1:48
        load(sprintf('LFPChan%02d',i),'LFP');
        lfp{i}=LFP.AD;
    end
    
    t = LFP.T;
    
end

%% extract trial

ccc

disp('please wait')

load allinone

% trial = 123

LFP = zeros(48,11501);
w = waitbar(0);
for trial = 1:99
    waitbar(trial/413,w)
    for i = 1:48
        LFP(i,:) = lfp{i}(trial,:);
    end
    save(sprintf('data/lfp_by_trial/LFP_trial_%03d.mat',trial),'LFP');
end
close(w)
clear lfp;

disp('extraction complete')

%%

