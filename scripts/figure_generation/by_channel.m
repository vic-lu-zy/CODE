function by_channel(f,cfg)

for i = 1:length(cfg.path_data)
    load(cfg.path_data{i});
end

nFreq_global = find(Axis.frequency>cfg.freq(1),1);
nFreq_low = find(Axis.frequency>cfg.freq(2),1);
nFreq_mid = find(Axis.frequency>cfg.freq(3),1);
nFreq_high = find(Axis.frequency>cfg.freq(4),1);

for ii = 1:48
    % print each channel
    figure(f)
    %%
    for jj = 1:4
        
        subplot(4,2,2*jj-1)
        
        SS = squeeze(median(Spect(cl==jj,ii,:,1:nFreq_global)))'...
            .*repmat(1:nFreq_global,size(Spect,3),1)';
        imagesc(Axis.time,Axis.frequency(1:nFreq_global),SS)
        axis xy
        
        subplot(4,2,2*jj)
        low = mean(SS(nFreq_low:nFreq_mid-1,:));
        high = mean(SS(nFreq_mid:nFreq_high,:));
        
        plot(Axis.time,low,Axis.time,high,'linewidth',2)
        
        axis tight
    end
    print(f,sprintf('%sChannel_#%02i',cfg.path_out,ii),'-dpng');
end

for ii = 1:3
    % print each array
    figure(f)
    %%
    for jj = 1:4
        
        subplot(4,2,2*jj-1)
        
        SS = squeeze(median(median(Spect(cl==jj,(ii-1)*16+(1:16),:,1:nFreq_global))))'...
            .*repmat(1:nFreq_global,size(Spect,3),1)';
        imagesc(Axis.time,Axis.frequency(1:nFreq_global),SS)
        axis xy
        
        subplot(4,2,2*jj)
        low = mean(SS(nFreq_low:nFreq_mid-1,:));
        high = mean(SS(nFreq_mid:nFreq_high,:));
        
        plot(Axis.time,low,Axis.time,high,'linewidth',2)
        
        axis tight
    end
    print(f,sprintf('%sArray_#%02i',cfg.path_out,ii),'-dpng');
end