function [t_EM] = drawTimeline_mv(fig,trial,range)

subplot(fig)

load ('RecordingVariables','Events');

%%
if ~isnan(Events.T.T65sac(trial))
    t_EM = Events.T.T65sac(trial);
    line(t_EM*[1 1],range,'Color','r','linewidth',2);
elseif ~isnan(Events.T.T66on(trial))
    t_EM = Events.T.T66on(trial);
    line(t_EM*[1 1],range,'Color','g','linewidth',2);
else
    t_EM = 0;
end
% 
% t2_reach = Events.T.Treach(trial);
% line(t2_reach*[1 1],range,'Color','y','linewidth',2);
