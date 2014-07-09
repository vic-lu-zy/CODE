function low_mid_freq_roi(trial)

load(sprintf('LFP_trial_%03d.mat',trial));
load('LFP_Timing');
load('RecordingVariables','Events');

figure(1);

t = Events.T.T65sac(trial)/1000;
    
for i = 1:3
    
    f = subplot(3,1,i);
    
    [S,F,T] = spectrogram(mean(LFP((i-1)*16+(1:16),1:2^13)),2^9,2^9-50,2^13,1000);
    
    low = mean(abs(S(1:find(F>10,1),:)));
    mid = mean(abs(S(find(F>20,1):find(F>40,1),:)));
%     
%     plot(T-1-t,low,T-1-t,mid);
%         
%     drawTimeline(f,trial,[0 5]);
%     
%     xlim([-.5 .5])

    plot(T(1:end-1)-1-t,diff(mid)-diff(low));
    xlim([-.5 .5])
%     drawTimeline(f,trial,[-1 1]);
        
end