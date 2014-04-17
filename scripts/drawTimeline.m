function t = drawTimeline(fig,trial,range)

subplot(fig)

% load(sprintf('LFPChan%02d.mat',electrode));
load ('RecordingVariables','Events');

t = zeros(13,1);
line([-999 7000]/1000,[0 0],'Color','k');

for i = [1 2 3 4 5 6 8 9 10 13 18 19]
    t(i) = eval(sprintf('Events.T.T%1d(trial)',i));
    line(t(i)*[1 1]/1000,range,'Color','k','linewidth',2);
end

%%
if ~isnan(Events.T.T65sac(trial))
    t(7) = Events.T.T65sac(trial);
    line(t(7)*[1 1]/1000,range,'Color','r','linewidth',2);
elseif ~isnan(Events.T.T66on(trial))
    t(7) = Events.T.T66on(trial);
    line(t(7)*[1 1]/1000,range,'Color','g','linewidth',2);
else
    t(7) = 0;
end

t(87) = Events.T.Treach(trial);
line(t(87)*[1 1]/1000,range,'Color','y','linewidth',2);
