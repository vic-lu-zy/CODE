% function print_spect_by_channel_chronux
ccc
%%
load('SPECT_ALL_IN_ONE')

%%
load T65sac
load T66on
load T67
load Treach
load Eye_traces
load Hand_traces

load cl65; cl65 = cl;
load cl66; cl66 = cl;
load cl_reach;

date = '20100407';

path_out = ['C:/Users/vic/Dropbox/thesis/figures/' date '/Spect/All/'];

%%
fig = figure(1);
set(fig,'Position',[-1919 1 1920 1004]);

for ii = 1
    
    figure(fig)
    h13 = subplot (5,4,13); % fixation
    ax13 = get(h13,'position');
    set(h13,'position',ax13); % prevent figure from shrinking when using colorbar
    
    subplot(5,4,13)
    S = 10*log10(squeeze(mean(Spect{4}(ii,:,:,:)))); 
%     mm = minmax(S(:)');
    mm = [-60 -40];
    imagesc(Axis{4}.time,Axis{4}.frequency,S',mm),axis xy
    colorbar
    
    for jj = 1:4
        subplot(5,4,(jj-1)*4+2) % saccade
        imagesc(Axis{2}.time,Axis{2}.frequency,...
            10*log10(squeeze(mean(Spect{2}(ii,cl65==jj,:,:))))',mm),axis xy
        line([0 0],minmax(Axis{2}.frequency),'color','w','linestyle','-.','linewidth',2)
        
        subplot(5,4,(jj-1)*4+3) % pursuit
        imagesc(Axis{3}.time,Axis{3}.frequency,...
            10*log10(squeeze(mean(Spect{3}(ii,cl66==jj,:,:))))',mm),axis xy
        line([0 0],minmax(Axis{3}.frequency),'color','w','linestyle','-.','linewidth',2)
        
        subplot(5,4,(jj-1)*4+4) % reach
        imagesc(Axis{5}.time,Axis{5}.frequency,...
            10*log10(squeeze(mean(Spect{5}(ii,h==jj,:,:))))',mm),axis xy
        line([0 0],minmax(Axis{5}.frequency),'color','w','linestyle','-.','linewidth',2)
    end
    
    %% eye and hand traces
    if ii == 1
        subplot(5,4,17)
        T = minmax(Axis{4}.time)*1000; T = T(1):T(end);
        Eye_x = extract_time_range(Eye.x,T67_start+1000,T);
        Eye_y = extract_time_range(Eye.y,T67_start+1000,T);
        plot(T/1000,Eye_x,'r',T/1000,Eye_y,'b');
        axis tight
        ylim(15*[-1 1])
        
        subplot(5,4,18)
        T = minmax(Axis{2}.time)*1000; T = T(1):T(end);
        Eye_x = extract_time_range(Eye.x,T65sac+1000,T);
        Eye_y = extract_time_range(Eye.y,T65sac+1000,T);
        plot(T/1000,Eye_x,'r',T/1000,Eye_y,'b')
        axis tight
        ylim(15*[-1 1])
        line([0 0],[-15 15],'color','k','linestyle','-.','linewidth',2)
        
        subplot(5,4,19)
        T = minmax(Axis{3}.time)*1000; T = T(1):T(end);
        Eye_x = extract_time_range(Eye.x,T66on+1000,T);
        Eye_y = extract_time_range(Eye.y,T66on+1000,T);
        plot(T/1000,Eye_x,'r',T/1000,Eye_y,'b');
        axis tight
        ylim(15*[-1 1])
        line([0 0],[-15 15],'color','k','linestyle','-.','linewidth',2)
        
        subplot(5,4,20)
        T = minmax(Axis{5}.time)*1000; T = T(1):T(end);
        Hand_x = extract_time_range(Hand.x,Treach+1000,T);
        Hand_y = extract_time_range(Hand.y,Treach+1000,T);
        Hand_x(Hand_x<-11)=nan;
        Hand_x(Hand_x>10)=nan;
        Hand_y(Hand_y<-10)=nan;
        plot(T/1000,Hand_x,'r',T/1000,Hand_y,'b');
        axis tight
        ylim(15*[-1 1])
        line([0 0],[-15 15],'color','k','linestyle','-.','linewidth',2)
    end
    %% labels
    
    array_name = {'PRR','PMd','PMd'};
    
    subplot(2,4,1)
    cla
    text(0,.4,sprintf(['Date = %s\n\n',...
        'Channel = %02i (%3s)\n',...
        'WindowSize = 300 ms\n',...
        'TimeStep = 30 ms \n\n',...
        'Each column displays a task\n',...
        'and each row displays a direction\n\n',...
        'All spectrograms are limited \nto [%2d %2d] dB with the colorbar\n',...
        'displayed below.\n\n',...
        'The dashed line in each figure \nindicate the alignment.\n\n',...
        'Note: Reach starts 700 ms after \nsaccade onset and 1500 ms after \npursuit onset.'],...
        date,ii,array_name{floor((ii-1)/16)+1},mm(1),mm(2)),'fontsize',14)
    axis off
    
    subplot(5,4,13)
    title('Fixation','fontsize',14)
    subplot(5,4,2)
    title('Saccade','fontsize',14)
    subplot(5,4,3)
    title('Pursuit','fontsize',14)
    subplot(5,4,4)
    title('Reach','fontsize',14)
    
    subplot(5,4,13)
    ylabel('Frequency (Hz)','fontsize',14)
    
    subplot(5,4,17)
    ylabel({'Eye/Hand', 'position (cm)'},'fontsize',14)
    
    subplot(5,4,2)
    ylabel('Right','fontsize',14)
    subplot(5,4,6)
    ylabel('Up','fontsize',14)
    subplot(5,4,10)
    ylabel('Left','fontsize',14)
    subplot(5,4,14)
    ylabel('Down','fontsize',14)
    
    subplot(5,4,17)
    xlabel('Time since middle of fixation (s)','fontsize',14)
    subplot(5,4,18)
    xlabel('Time since saccade onset (s)','fontsize',14)
    subplot(5,4,19)
    xlabel('Time since pursuit onset (s)','fontsize',14)
    subplot(5,4,20)
    xlabel('Time since reach onset (s)','fontsize',14)
    
    %%
    
    hgexport(fig,sprintf([path_out '%02i'],ii),hgexport('factorystyle'),'Format','png')
end
