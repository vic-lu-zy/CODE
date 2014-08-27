
params.Fs = 1000;
params.tapers = [2 3];
params.fpass = [0 50];
movingwin = [.3 .03];

%%
% 
% load('LFP_ALL_IN_ONE')
% LFP_ALL_IN_ONE_SACCADE = double(LFP_ALL_IN_ONE_SACCADE)*1000;
% LFP_ALL_IN_ONE_PURSUIT = double(LFP_ALL_IN_ONE_PURSUIT)*1000;
% LFP_ALL_IN_ONE_FIXATION = double(LFP_ALL_IN_ONE_FIXATION)*1000;
% LFP_ALL_IN_ONE_REACH = double(LFP_ALL_IN_ONE_REACH)*1000;

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
f = figure(1);
for ii = 1:48
    
    figure(f)
    clf
    subplot (5,4,13)
    lfp = squeeze(LFP_ALL_IN_ONE_FIXATION(ii,:,:));
    [P67,T67,F67] = mtspecgramc(lfp(1,:),movingwin,params);
    for nn = 2:numb_trials_67
        P67 = P67 + mtspecgramc(lfp(nn,:),movingwin,params);
    end
    S = 10*log10(P67'/numb_trials_67); mm = minmax(S(:)');
    imagesc(T67-.5,F67,S,mm),axis xy
    colorbar
    
    for jj = 1:4
        subplot(5,4,(jj-1)*4+2)
        lfp = squeeze(LFP_ALL_IN_ONE_SACCADE(ii,cl65==jj,:));
        [P65,T65,F65] = mtspecgramc(lfp(1,:),movingwin,params);
        for nn = 2:numb_trials_65(jj)
            P65 = P65 + mtspecgramc(lfp(nn,:),movingwin,params);
        end
        imagesc(T65-.5,F65,10*log10(P65'/numb_trials_66(jj)),mm),axis xy
        line([0 0],[0 50],'color','w','linestyle','-.','linewidth',2)
%         colorbar
        
        
        
        subplot(5,4,(jj-1)*4+3)
        lfp = squeeze(LFP_ALL_IN_ONE_PURSUIT(ii,cl66==jj,:));
        [P66,T66,F66] = mtspecgramc(lfp(1,:),movingwin,params);
        for nn = 2:numb_trials_66(jj)
            P66 = P66 + mtspecgramc(lfp(nn,:),movingwin,params);
        end
        imagesc(T66-.5,F66,10*log10(P66'/numb_trials_66(jj)),mm),axis xy
        line([0 0],[0 50],'color','w','linestyle','-.','linewidth',2)
%         colorbar

        
        subplot(5,4,(jj-1)*4+4)
        lfp = squeeze(LFP_ALL_IN_ONE_REACH(ii,h==jj,:));
        [P8,T8,F8] = mtspecgramc(lfp(1,:),movingwin,params);
        for nn = 2:numb_trials_8(jj)
            P8 = P8 + mtspecgramc(lfp(nn,:),movingwin,params);
        end
        imagesc(T8-.5,F8,10*log10(P8'/numb_trials_8(jj)),mm),axis xy
        line([0 0],[0 50],'color','w','linestyle','-.','linewidth',2)
%         colorbar
        
    end
    
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
    
    %% labels
    
    array_name = {'PRR','PRR','PMd'};
    
    subplot(2,4,1)
    cla
    text(0,.5,sprintf('Channel = %02i (%3s)\n\nEach column displays a task\nand each row displays a direction\n\nAll spectrograms are limited \nto [%8.2f %8.2f] dB',...
        ii,array_name{floor((ii-1)/16)+1},mm(1),mm(2)),'fontsize',14)
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
    path_out = 'C:/Users/vic/Dropbox/thesis/figures/20100412/Spect/All/';

    hgexport(f,sprintf([path_out '%02i'],ii),hgexport('factorystyle'),'Format','png')
end
