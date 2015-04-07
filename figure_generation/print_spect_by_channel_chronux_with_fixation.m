% function print_spect_by_channel_chronux
ccc
%% Loading
if ~exist('Spect','var')
% only load if the variables aren't in the workspace
    load('SPECT_ALL_IN_ONE')

    load T65sac
    ind65 = find(~isnan(T65sac));
    load T66on
    ind66 = find(~isnan(T66on));
    load T67
    ind67 = find(~isnan(T67));
    load Treach
    load Eye_traces
    load Hand_traces
    
    load cl65; cl65 = cl;
    load cl66; cl66 = cl;
    load cl_hand; h = cl;
end
date = '20101124';

% path_out = ['C:/Users/vic/Dropbox/thesis/figures/' date '/Spect/All/Opposite_Direction/'];
path_out = ['C:/Users/vic/Dropbox/thesis/figures/' date '/Spect/All/Same_Direction/'];
%%
fig = figure(1);
% set(fig,'Position',[-1919 1 1920 1004]);
set(fig,'Position',[1 41 1920 964]);

for ii = 1:48
    
    figure(fig)
    colormap jet
    vec = @(x) x(:)';
    mm = minmax(vec(10*log10(squeeze(mean(Spect{4}(ii,:,:,:))))));
    
    subplot (5,5,21)
    
    cs = linspace(mm(1),mm(2));
    imagesc(cs,[0 .5],cs)
    axis image
    title('Colorbar')
    
    for jj = 1:4
%         jjj = 4-jj;
        jjj = jj;
        subplot(5,5,(jj-1)*5+2)
        S = 10*log10(squeeze(mean(Spect{4}(ii,h(ind67)==jjj,:,:))));
        imagesc(Axis{4}.time,Axis{4}.frequency,S',mm),axis xy
        title(sprintf('#ofTrials = %2i', sum(h(ind67)==jjj)),'fontsize',14);
        subplot(5,5,(jj-1)*5+3) % saccade
        imagesc(Axis{2}.time,Axis{2}.frequency,...
            10*log10(squeeze(mean(Spect{2}(ii,h(ind65)==jjj & cl65==jj,:,:))))',mm),axis xy
        line([0 0],minmax(Axis{2}.frequency),'color','w','linestyle','-.','linewidth',2)
        title(sprintf('#ofTrials = %2i', sum(h(ind65)==jjj & cl65==jj)),'fontsize',14);
        subplot(5,5,(jj-1)*5+4) % pursuit
        imagesc(Axis{3}.time,Axis{3}.frequency,...
            10*log10(squeeze(mean(Spect{3}(ii,h(ind66)==jjj & cl66==jj,:,:))))',mm),axis xy
        line([0 0],minmax(Axis{3}.frequency),'color','w','linestyle','-.','linewidth',2)
        title(sprintf('#ofTrials = %2i', sum(h(ind66)==jjj & cl66==jj)),'fontsize',14);
        subplot(5,5,(jj-1)*5+5) % reach
        imagesc(Axis{5}.time,Axis{5}.frequency,...
            10*log10(squeeze(mean(Spect{5}(ii,h==jj,:,:))))',mm),axis xy
        line([0 0],minmax(Axis{5}.frequency),'color','w','linestyle','-.','linewidth',2)
        title(sprintf('#ofTrials = %2i', sum(h==jj)),'fontsize',14);
    end
    
    %% eye and hand traces
    if ii == 1
        subplot(5,5,22)
        T = minmax(Axis{4}.time)*1000; T = T(1):T(end);
        Eye_x = extract_time_range(Eye.x,T67+1000,T);
        Eye_y = extract_time_range(Eye.y,T67+1000,T);
        plot(T/1000,Eye_x,'r',T/1000,Eye_y,'b');
        axis tight
        ylim(20*[-1 1])
        
        subplot(5,5,23)
        T = minmax(Axis{2}.time)*1000; T = T(1):T(end);
        Eye_x = extract_time_range(Eye.x,T65sac+1000,T);
        Eye_y = extract_time_range(Eye.y,T65sac+1000,T);
        plot(T/1000,Eye_x,'r',T/1000,Eye_y,'b')
        axis tight
        ylim(20*[-1 1])
        line([0 0],[-15 15],'color','k','linestyle','-.','linewidth',2)
        
        subplot(5,5,24)
        T = minmax(Axis{3}.time)*1000; T = T(1):T(end);        
        Eye_x = extract_time_range(Eye.x,T66on+1000,T);
        Eye_y = extract_time_range(Eye.y,T66on+1000,T);
        plot(T/1000,Eye_x,'r',T/1000,Eye_y,'b');
        axis tight
        ylim(20*[-1 1])
        line([0 0],[-15 15],'color','k','linestyle','-.','linewidth',2)
        
        subplot(5,5,25)
        T = minmax(Axis{5}.time)*1000; T = T(1):T(end);
        Hand_x = extract_time_range(Hand.x,Treach+1000,T);
        Hand_y = extract_time_range(Hand.y,Treach+1000,T);
        Hand_x(Hand_x<-11)=nan;
        Hand_x(Hand_x>10)=nan;
        Hand_y(Hand_y<-10)=nan;
        plot(T/1000,Hand_x,'r',T/1000,Hand_y,'b');
        axis tight
        ylim(20*[-1 1])
        line([0 0],[-15 15],'color','k','linestyle','-.','linewidth',2)
    end
    %% labels
    
    array_name = {'PRR','PRR','PRR'};
    
    subplot(5,5,6)
    cla
    text(-.5,0,sprintf(['Date = %s\n\n',...
        'Channel = %02i (%3s)\n',...
        'WindowSize = 300 ms\n',...
        'TimeStep = 30 ms \n\n',...
        'Each column displays a task\n',...
        'and each row displays a direction\n',...
        'e.g. row2 is upward eye and/or hand movements\n',...
        'The title in each subfigure indicate\n',...
        'the number of trials with the corresponding task\n\n',...
        'All spectrograms are limited \nto [%2.0f %2.0f] dB with the colorbar\n',...
        'displayed below.\n\n',...
        'The dashed line in each figure \nindicate the alignment.\n\n',...
        'Note: Reach starts 700 ms after \nsaccade onset and 1500 ms after \npursuit onset.'],...
        date,ii,array_name{floor((ii-1)/16)+1},mm(1),mm(2)),'fontsize',12)
    axis off
       
    subplot(5,5,22)
    ylabel({'Eye/Hand', 'position (cm)'},'fontsize',14)
    
    subplot(5,5,2)
    ylabel('Right','fontsize',14)
    subplot(5,5,7)
    ylabel('Up','fontsize',14)
    subplot(5,5,12)
    ylabel('Left','fontsize',14)
    subplot(5,5,17)
    ylabel('Down','fontsize',14)
    
    subplot(5,5,22)
    xlabel('fixation','fontsize',14)
    subplot(5,5,23)
    xlabel('saccade','fontsize',14)
    subplot(5,5,24)
    xlabel('pursuit','fontsize',14)
    subplot(5,5,25)
    xlabel('reach','fontsize',14)
    
    %%
    
    hgexport(fig,sprintf([path_out '%02i'],ii),hgexport('factorystyle'),'Format','png')
end
