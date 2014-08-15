function by_channel(f,cfg)

for i = 1:length(cfg.path_data)
    load(cfg.path_data{i});
end

nFreq_global = find(Axis.frequency<cfg.freq(1),1,'last');
nFreq_low = find(Axis.frequency>cfg.freq(2),1);
nFreq_mid = find(Axis.frequency>cfg.freq(3),1);
nFreq_high = find(Axis.frequency<cfg.freq(4),1,'last');

%% Print each Channel
for ii = 1:48
    
    num_channel = mod(ii-1,16)+1;
    num_array   = cfg.array_number(floor((ii-1)/16)+1);
    
    figure(f)
    
    %% draw contents
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
        legend(sprintf('[%03i~%03i] Hz',cfg.freq(2),cfg.freq(3)),...
            sprintf('[%03i~%03i] Hz',cfg.freq(3),cfg.freq(4)))
        ylim([0 .5])
        %         axis tight
    end
    
    %% insert texts
    subplot 421
    
    title(sprintf('Channel #%02i of Array #%i (%s)',...
        num_channel,num_array,cfg.array_name{num_array}),...
        'fontsize',18);
    
    subplot 422
    
    title('Averaged power per frequency band','fontsize',18)
    
    
    %% print
    print(f,sprintf('%sArray#%i_Channel#%02i',cfg.path_out,num_array,num_channel),'-dpng');
end

%% print each array
for ii = 1:3
    
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
        legend(sprintf('[%03i~%03i] Hz',cfg.freq(2),cfg.freq(3)),...
            sprintf('[%03i~%03i] Hz',cfg.freq(3),cfg.freq(4)))
        axis tight
    end
    
    subplot 421
    
    title(sprintf('Average power of Array #%i (%s)',...
        cfg.array_number(ii),cfg.array_name{cfg.array_number(ii)}),...
        'fontsize',18);
    
    subplot 422
    
    title('Averaged power per frequency band','fontsize',18)
    
    print(f,sprintf('%sArray_#%02i',cfg.path_out,cfg.array_number(ii)),'-dpng');
end