ccc

load LFP_ALL_IN_ONE;

load T65sac
load T66on
load Treach

LFP_ALL_IN_ONE_SACCADE = zeros(48,sum(~isnan(T65sac)),1501);
% LFP_ALL_IN_ONE_PURSUIT = zeros(48,sum(~isnan(T66on)),2501);
% LFP_ALL_IN_ONE_REACH = zeros(48,sum(~isnan(Treach)),1501);

for ii = 1:48
    LFP_ALL_IN_ONE_SACCADE(ii,:,:) = extract_time_range(LFP_ALL_IN_ONE(:,ii,:),T65sac+1000,-500:1000)';
%     LFP_ALL_IN_ONE_PURSUIT(ii,:,:) = extract_time_range(LFP_ALL_IN_ONE(:,ii,:),T66on+1000,-500:2000)';
%     LFP_ALL_IN_ONE_REACH(ii,:,:) = extract_time_range(LFP_ALL_IN_ONE(:,ii,:),Treach+1000,-500:500)';    
end
