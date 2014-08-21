% function print_lfp(cfg)
ccc

load('LFP_ALL_IN_ONE','LFP_ALL_IN_ONE_REACH')
LFP_ALL_IN_ONE_REACH = double(LFP_ALL_IN_ONE_REACH);
load cl_hand
cl = h;

path_out = 'C:/Users/vic/Dropbox/thesis/figures/20100412/LFP/Reach/';
time_range = -500:1000;

Fs = 1000;
n = 4;
fpass = [0 15; 15 45; 40 80];
[b1,a1] = butter(n,2*fpass(1,2)*2/Fs,'low');
[b2,a2] = butter(n,fpass(2,:)*2/Fs);
% [b3,a3] = butter(n,fpass(3,:)*2/Fs);

f = figure(1);

for ii = 1:48
    for jj = 1:4
        lfp = squeeze(LFP_ALL_IN_ONE_REACH(ii,cl==jj,:));
%         mm = minmax(lfp(:)');
        subplot (3,4,jj)
        plot(time_range,mean(lfp),'linewidth',2)
        ylim([-.05 .05])
        xlim([-500 1000])
        grid minor
%         axis tight
        
        subplot (3,4,jj+4)
        plot(time_range,mean(filtfilt(b1,a1,lfp'),2),'linewidth',2)
        ylim([-.05 .05])
        xlim([-500 1000])
        grid minor
%         axis tight
        
        subplot (3,4,jj+8)
        plot(time_range,mean(filtfilt(b2,a2,lfp'),2),'linewidth',2)
        ylim([-1 1]*.015)
        xlim([-500 1000])
        grid minor
%         axis tight
        
%         subplot (4,4,jj+12)
%         plot(time_range,mean(filtfilt(b3,a3,lfp'),2),'linewidth',2)
%         ylim([-1 1]*.01)
%         xlim([-500 1000])
%         grid minor
%         axis tight
        
    end
    
    subplot 341
    title('Dir=1','fontsize',18);
    
    subplot 342
    title('Dir=2','fontsize',18);
    
    subplot 343
    title('Dir=3','fontsize',18);
    
    subplot 344
    title('Dir=4','fontsize',18);
    
    subplot (3,4,1)
    ylabel('Raw Signal','fontsize',18);
    subplot (3,4,5)
    ylabel(sprintf('[%02i %02i] Hz',fpass(1,1),fpass(1,2)),'fontsize',18);
    subplot (3,4,9)
    ylabel(sprintf('[%02i %02i] Hz',fpass(2,1),fpass(2,2)),'fontsize',18);
%     subplot (4,4,13)
%     ylabel(sprintf('[%02i %02i] Hz',fpass(3,1),fpass(3,2)),'fontsize',18);
    
    print(f,sprintf([path_out '%02i'],ii),'-dpng')
end
