ccc

load LFP_ALL_IN_ONE;

%%
load T65sac
T = repmat(T65sac,1,48)+1000;
trials = ~isnan(T(:,1));
T = T(trials,:);

LFP = reshape(LFP_ALL_IN_ONE(trials,:,:),[],size(LFP_ALL_IN_ONE,3));

LFP_ALL_IN_ONE_SACCADE = extract_time_range(LFP,T(:),-500:1000);
LFP_ALL_IN_ONE_SACCADE = reshape(LFP_ALL_IN_ONE_SACCADE,1501,[],48);
LFP_ALL_IN_ONE_SACCADE = permute(LFP_ALL_IN_ONE_SACCADE,[3 2 1]);

%%
load T66on
T = repmat(T66on,1,48)+1000;
trials = ~isnan(T(:,1)); 
T = T(trials,:);

LFP = reshape(LFP_ALL_IN_ONE(trials,:,:),[],size(LFP_ALL_IN_ONE,3));

LFP_ALL_IN_ONE_PURSUIT = extract_time_range(LFP,T(:),-500:2000);
LFP_ALL_IN_ONE_PURSUIT = reshape(LFP_ALL_IN_ONE_PURSUIT,2501,[],48);
LFP_ALL_IN_ONE_PURSUIT = permute(LFP_ALL_IN_ONE_PURSUIT,[3 2 1]);

%%
load T67
T = repmat(T67,1,48);
trials = ~isnan(T(:,1)); 
T = T(trials,:);

LFP = reshape(LFP_ALL_IN_ONE(trials,:,:),[],size(LFP_ALL_IN_ONE,3));

LFP_ALL_IN_ONE_FIXATION = extract_time_range(LFP,T(:),-200:2000);
LFP_ALL_IN_ONE_FIXATION = reshape(LFP_ALL_IN_ONE_FIXATION,2201,[],48);
LFP_ALL_IN_ONE_FIXATION = permute(LFP_ALL_IN_ONE_FIXATION,[3 2 1]);

%%
load Treach
T = repmat(Treach,1,48)+1000;
trials = ~isnan(T(:,1));
T = T(trials,:);

LFP = reshape(LFP_ALL_IN_ONE(trials,:,:),[],size(LFP_ALL_IN_ONE,3));

LFP_ALL_IN_ONE_REACH = extract_time_range(LFP,T(:),-500:1000);
LFP_ALL_IN_ONE_REACH = reshape(LFP_ALL_IN_ONE_REACH,1501,[],48);
LFP_ALL_IN_ONE_REACH = permute(LFP_ALL_IN_ONE_REACH,[3 2 1]);
