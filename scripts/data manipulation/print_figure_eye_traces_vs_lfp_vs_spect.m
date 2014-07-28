ccc

load T66on
load Axis
load Eye_traces

f = figure;

for ii = find(~isnan(T66on))
    
    load(sprintf('D:/NPL_DATA/M20100407_456/psd_by_trial_Pursuit_128/psd_trial_%03i',ii))
    load(sprintf('D:/NPL_DATA/M20100407_456/lfp_by_trial/LFP_trial_%03i',ii))
    
    %%
    lfp = extract_time_range(mean(LFP(17:end,:)),T66on(ii)+1000,-500:2500);
    SS = squeeze(mean(S(17:end,:,2:31)));
        
    x = extract_time_range(Eye.x(ii,:),T66on(ii)+1000,-500:2500);
    y = extract_time_range(Eye.y(ii,:),T66on(ii)+1000,-500:2500);
    
    
    subplot 311
    plot(-500:2500,x,-500:2500,y), axis tight
    title(sprintf('Trial #%03i',ii),'fontsize',30)
    ylabel('Eye Trace','fontsize',16)
    
    subplot 312
    plot(-500:2500,lfp), axis tight
    ylabel('LFP time series','fontsize',16)
    
    
    subplot 313
    imagesc(Axis.time,Axis.frequency(2:31),log(SS'.*repmat(1:30,575,1)')), axis xy
    ylabel('Mean Power Spectrum','fontsize',16)
    
    xlabel('Time from onset(ms)','fontsize',16)
    
    print(f,['C:\Users\vic\Google Drive\Thesis\figures\20100407\trial_' num2str(ii) '_128'],'-dpng')
end
close(f)