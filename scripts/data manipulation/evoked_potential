Fs = 1000;
n  = 4;
T = -500:1000;

fpass = [0 10; 10 25; 25 45];

for kk = 1:4
    
    lfp = double(extract_time_range(LFP.AD(ind(cl==kk),:),T66on(ind(cl==kk))+1000,T));
    
    
    for ii = 1:size(lfp,2)
        
        % loop thru trials
        
        [b a] = butter(n,2*fpass(1,2)*2/Fs,'low');
        lfp(:,ii,2) = filtfilt(b,a,lfp(:,ii,1));
        
        for jj = 2:3
            [b,a] = butter(n,fpass(jj,:)*2/Fs);
            lfp(:,ii,jj+1) = filtfilt(b,a,lfp(:,ii,1));
        end
        
    end
    
    x = squeeze(mean(lfp,2));
    
    for ii = 1:4
        subplot(4,4,(ii-1)*4+kk)
        plot(T,x(:,ii))
        axis tight
    end
end