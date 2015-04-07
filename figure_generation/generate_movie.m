% function generate_movie

load LFPxeye
eyex = LFP.rawData.ad;
eyex(eyex>14)=nan;
eyex = eyex - nanmedian(eyex);

load LFPyeye
eyey = LFP.rawData.ad;
eyey(eyey<-12)=nan;
eyey = eyey - nanmedian(eyey);

load LFPChan01
lfp = LFP.rawData.ad;

clear Events LFP

%%

params.Fs = 1;
params.tapers = [2 3];
params.fpass = [0 60]/1000;
movingwin = [300 30];

%%
[S,T,F] = mtspecgramc(lfp,movingwin,params);

%%
SS = log(S.*repmat(1:31,size(S,1),1))';
% SS = log(S');
%%
fig = figure('Position',[-1919 1 1920 1004],...
    'PaperPositionMode', 'auto','Visible','off');

writerObj = VideoWriter('S:/spect','MPEG-4');

%%
open(writerObj);

clf(fig)

n = 100;
% t = 1:length(T);
h1 = imagesc(T(1:n)-T(1),F*1000,SS(:,1:n));
axis xy

hold on


% (T(1:n)-T(1)),lfp(T(1:n))+45,...
h2 = plot((T(1:n)-T(1)),eyex(T(1:n))+30,...
    (T(1:n)-T(1)),eyey(T(1:n))+30,'linewidth',4);
leg = legend({'horizontal','vertical'},'fontsize',20);

% line([0 T(n)],[45 45],'color','k','linewidth',4,'linestyle','-.')
line([0 T(n)],[30 30],'color','k','linewidth',4,'linestyle','-.')
time_string = text(100,55,'start','fontsize',24,'BackgroundColor','w');



title('Spectrogram vs. Eye Position','fontsize',24)
ylabel('Frequency (Hz)','fontsize',20)
xlabel('Time Index (ms)','fontsize',20)

% writeVideo(writerObj,im2frame(zbuffer_cdata(fig)));

w = waitbar(0);
% nn = length(T)-n;
nn = length(T)/2;
for ii = 1:nn
    waitbar(ii/nn,w,[num2str(ii/nn*100) '%']);
    tt = T(ii+(1:n));
    %     set(h1,'XData',tt);
    set(h1,'CData',SS(:,ii+(1:n)));
    %     set(ax,'xlim',[tt(1) tt(end)])
    %     set(h2(1),'XData',tt);
%     set(h2(1),'YData',lfp(tt)*10+45)
    set(h2(1),'YData',eyex(tt)+30)
    %     set(h2(2),'XData',tt);
    set(h2(2),'YData',eyey(tt)+30)
    
    set(time_string,'String',...
        sprintf('%02i:%02i:%03i',unit_convert(T(ii),[60000 1000 1])))    
    writeVideo(writerObj,im2frame(zbuffer_cdata(fig)));
end
close(w)
close(writerObj)