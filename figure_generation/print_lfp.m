% function print_lfp(cfg)
ccc

load LFP_ALL_IN_ONE_PURSUIT
% LFP_ALL_IN_ONE_SACCADE = double(LFP_ALL_IN_ONE_SACCADE);
load cl66
load T66on

ind = find(~isnan(T66on));

path_out = '/home/vic/Dropbox/thesis/figures/20100412/LFP/Pursuit/';

time_range = -500:2000;

Fs = 1000;
n = 4;
fpass = [0 10; 10 25; 25 45];
[b1,a1] = butter(n,2*fpass(1,2)*2/Fs,'low');
[b2,a2] = butter(n,fpass(2,:)*2/Fs);
[b3,a3] = butter(n,fpass(3,:)*2/Fs);

f = figure(1);

for ii = 1:48
    if ~isdir([path_out num2str(ii)])
        mkdir([path_out num2str(ii)])
        mkdir([path_out num2str(ii) '/1'])
        mkdir([path_out num2str(ii) '/2'])
        mkdir([path_out num2str(ii) '/3'])
        mkdir([path_out num2str(ii) '/4'])
    end
    for jj = 1:178
        
        lfp = squeeze(LFP_ALL_IN_ONE_PURSUIT(ii,jj,:));
        mm = minmax(lfp');
        subplot 221
        plot([0 0],mm,'r--',-500:2000,lfp,'linewidth',2)
        grid minor
        axis tight
        xlabel('Time (ms)')
        title(sprintf('Channel=%02i, Trial=%03i, Dir=%i',ii,ind(jj),cl(jj)),'fontsize',18)
        
        subplot 222
        plot([0 0],mm,'r--',-500:2000,filtfilt(b1,a1,lfp),'linewidth',2)
        grid minor
        axis tight
        title('[0 10] Hz','fontsize',18)
        
        subplot 223
        plot([0 0],mm,'r--',-500:2000,filtfilt(b2,a2,lfp),'linewidth',2)
        grid minor
        axis tight
        title('[10 25] Hz','fontsize',18)
        
        subplot 224
        plot([0 0],mm,'r--',-500:2000,filtfilt(b3,a3,lfp),'linewidth',2)
        grid minor
        axis tight
        title('[25 45] Hz','fontsize',18)
        
        print(f,sprintf([path_out num2str(ii) '/%i/%03i'],cl(jj),ind(jj)),'-dpng')
    end
end
