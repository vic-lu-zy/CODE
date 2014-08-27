ccc

load LFP_ALL_IN_ONE;

to_do = [0,0,1,0];
%% saccade
if to_do(1)
    load T65sac
    T = repmat(T65sac,1,48)+1000;
    trials = ~isnan(T(:,1));
    T = T(trials,:);
    
    LFP = reshape(LFP_ALL_IN_ONE(trials,:,:),[],size(LFP_ALL_IN_ONE,3));
    
    t_int = -500:500;
    LFP_ALL_IN_ONE_SACCADE = extract_time_range(LFP,T(:),t_int);
    LFP_ALL_IN_ONE_SACCADE = reshape(LFP_ALL_IN_ONE_SACCADE,length(t_int),[],48);
    LFP_ALL_IN_ONE_SACCADE = permute(LFP_ALL_IN_ONE_SACCADE,[3 2 1]);
end
%% pursuit
if to_do(2)
    load T66on
    T = repmat(T66on,1,48)+1000;
    trials = ~isnan(T(:,1));
    T = T(trials,:);
    
    LFP = reshape(LFP_ALL_IN_ONE(trials,:,:),[],size(LFP_ALL_IN_ONE,3));
    
    t_int = -500:2000;
    LFP_ALL_IN_ONE_PURSUIT = extract_time_range(LFP,T(:),t_int);
    LFP_ALL_IN_ONE_PURSUIT = reshape(LFP_ALL_IN_ONE_PURSUIT,length(t_int),[],48);
    LFP_ALL_IN_ONE_PURSUIT = permute(LFP_ALL_IN_ONE_PURSUIT,[3 2 1]);
end
%% fixation
if to_do(3)
    load T67
    T = repmat(T67_start,1,48)+1000;
    trials = ~isnan(T(:,1));
    T = T(trials,:);
    
    LFP = reshape(LFP_ALL_IN_ONE(trials,:,:),[],size(LFP_ALL_IN_ONE,3));
    
    t_int = -500:500;
    LFP_ALL_IN_ONE_FIXATION = extract_time_range(LFP,T(:),t_int);
    LFP_ALL_IN_ONE_FIXATION = reshape(LFP_ALL_IN_ONE_FIXATION,length(t_int),[],48);
    LFP_ALL_IN_ONE_FIXATION = permute(LFP_ALL_IN_ONE_FIXATION,[3 2 1]);
end
%% reach
if to_do(4)
    load Treach
    T = repmat(Treach,1,48)+1000;
    trials = ~isnan(T(:,1));
    T = T(trials,:);
    
    LFP = reshape(LFP_ALL_IN_ONE(trials,:,:),[],size(LFP_ALL_IN_ONE,3));
    
    t_int = -500:1000;
    LFP_ALL_IN_ONE_REACH = extract_time_range(LFP,T(:),t_int);
    LFP_ALL_IN_ONE_REACH = reshape(LFP_ALL_IN_ONE_REACH,length(t_int),[],48);
    LFP_ALL_IN_ONE_REACH = permute(LFP_ALL_IN_ONE_REACH,[3 2 1]);
end
%%
save('LFP_ALL_IN_ONE',...
    'LFP_ALL_IN_ONE',...
    'LFP_ALL_IN_ONE_SACCADE',...
    'LFP_ALL_IN_ONE_PURSUIT',...
    'LFP_ALL_IN_ONE_FIXATION',...
    'LFP_ALL_IN_ONE_REACH');