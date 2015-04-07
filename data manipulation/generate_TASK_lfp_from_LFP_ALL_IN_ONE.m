function generate_TASK_lfp_from_LFP_ALL_IN_ONE
% ccc

to_do = [1,1,1,1]; %sac,pur,fix,reach

if exist([pwd '/LFP_ALL_IN_ONE.mat'],'file')
    load LFP_ALL_IN_ONE;
else
    load([pwd '/lfp_by_channel/LFPChan01']);
    LFP_ALL_IN_ONE = zeros([48 size(LFP.AD,1) size(LFP.AD,2)],'single');
    LFP_ALL_IN_ONE(1,:,:) = LFP.AD;
    for ii = 1:48
        filename = sprintf('/lfp_by_channel/LFPChan%02i',ii);
        load([pwd filename]);
        LFP_ALL_IN_ONE(ii,:,:) = LFP.AD;
    end
    LFP_ALL_IN_ONE = permute(LFP_ALL_IN_ONE,[2 1 3]);
    clear LFP
end

if ~exist('LFP','var')
    LFP{1} = LFP_ALL_IN_ONE;
    clear LFP_ALL_IN_ONE
end

task_timing = {[],-500:1000,-500:2500,-500:1000,-500:1000};

for task = 2:5
    switch task
        case 2
            load T65sac
            T = repmat(T65sac,1,48)+1000;
        case 3
            load T66on
            T = repmat(T66on,1,48)+1000;
        case 4
            load T67
            T = repmat(T67,1,48)+1000;
        case 5
            load Treach
            T = repmat(Treach,1,48)+1000;
    end
    if to_do(task-1)
        trials = ~isnan(T(:,1));
        T = T(trials,:);
        lfp = reshape(LFP{1}(trials,:,:),[],size(LFP{1},3));
        lfp = extract_time_range(lfp,T(:),task_timing{task});
        lfp = reshape(lfp,length(task_timing{task}),[],48);
        LFP{task} = permute(lfp,[3 2 1]);
    end
end
%%
save('LFP_ALL_IN_ONE','LFP','task_timing');