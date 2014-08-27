
% load('LFP_ALL_IN_ONE')

%%
load T67
load T65sac
load T66on
load Treach
load Eye_traces
load Hand_traces

load cl65; cl65 = cl;
load cl66; cl66 = cl;
load cl_reach;

for ii = 1:4
    numb_trials_65(ii) = sum(cl65==ii);
    numb_trials_66(ii) = sum(cl66==ii);
    numb_trials_8(ii) = sum(h==ii);
end
numb_trials_67 = size(LFP_ALL_IN_ONE_FIXATION,2);

%%
f = figure(2);
clf
%% eye and hand traces

subplot(5,4,17)
T = minmax(T67)*1000-500; T = T(1):T(end);
Eye_x = extract_time_range(Eye.x,T67_start+1000,T);
Eye_y = extract_time_range(Eye.y,T67_start+1000,T);
plot(T/1000,Eye_x,'r',T/1000,Eye_y,'b');
axis tight
ylim(15*[-1 1])

subplot(5,4,18)
T = minmax(T65)*1000-500; T = T(1):T(end);
Eye_x = extract_time_range(Eye.x,T65sac+1000,T);
Eye_y = extract_time_range(Eye.y,T65sac+1000,T);
plot(T/1000,Eye_x,'r',T/1000,Eye_y,'b')
axis tight
ylim(15*[-1 1])
line([0 0],[-15 15],'color','k','linestyle','-.','linewidth',2)

subplot(5,4,19)
T = minmax(T66)*1000-500; T = T(1):T(end);
Eye_x = extract_time_range(Eye.x,T66on+1000,T);
Eye_y = extract_time_range(Eye.y,T66on+1000,T);
plot(T/1000,Eye_x,'r',T/1000,Eye_y,'b');
axis tight
ylim(15*[-1 1])
line([0 0],[-15 15],'color','k','linestyle','-.','linewidth',2)

subplot(5,4,20)
T = minmax(T8)*1000-500; T = T(1):T(end);
Hand_x = extract_time_range(Hand.x,Treach+1000,T);
Hand_y = extract_time_range(Hand.y,Treach+1000,T);
Hand_x(Hand_x<-11)=nan;
Hand_x(Hand_x>10)=nan;
Hand_y(Hand_y<-10)=nan;
plot(T/1000,Hand_x,'r',T/1000,Hand_y,'b');
axis tight
ylim(15*[-1 1])
line([0 0],[-15 15],'color','k','linestyle','-.','linewidth',2)

for ii = 1:48
    
    figure(f)

    subplot (5,4,13)
    plot(-500:500,squeeze(mean(LFP_ALL_IN_ONE_FIXATION(ii,1:numb_trials_67,:))));
    
    for jj = 1:4
        subplot(5,4,(jj-1)*4+2)
        plot(-500:500,squeeze(mean(LFP_ALL_IN_ONE_SACCADE(ii,cl65==jj,:))));
        
        subplot(5,4,(jj-1)*4+3)
        plot(-500:2000,squeeze(mean(LFP_ALL_IN_ONE_PURSUIT(ii,cl66==jj,:))));
        
        subplot(5,4,(jj-1)*4+4)
        plot(-500:1000,squeeze(mean(LFP_ALL_IN_ONE_REACH(ii,h==jj,:))));
    end
    
    
    
    %% labels
    
    array_name = {'PRR','PRR','PMd'};
    
    subplot(2,4,1)
    cla
    text(0,.5,sprintf('Channel = %02i (%3s)\n\nEach column displays a task\nand each row displays a direction',...
        ii,array_name{floor((ii-1)/16)+1}),'fontsize',14)
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
    ylabel('LFP (\muV)','fontsize',14)
    
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
    path_out = 'C:/Users/vic/Dropbox/thesis/figures/20100412/LFP/All/';
    hgexport(f,sprintf([path_out '%02i'],ii),hgexport('factorystyle'),'Format','png')
end
