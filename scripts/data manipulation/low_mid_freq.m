function low_mid_freq(trial)



load(sprintf('LFP_trial_%03d.mat',trial));
load('LFP_Timing')

figure(1);

for i = 1:3
    f = subplot(3,1,i);
    
    [S,F,T] = spectrogram(mean(LFP((i-1)*16+(1:16),1:2^13)),2^9,2^9-50,2^13,1000);
    
    low = mean(abs(S(1:find(F>10,1),:)));
    mid = mean(abs(S(find(F>20,1):find(F>40,1),:)));
    
    plot(T-1,low,T-1,mid);
        
    drawTimeline(f,trial,[0 5]);
    
    axis tight
    
end