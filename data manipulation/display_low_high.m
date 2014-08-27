% close all
x = (squeeze(mean(mean(Spect(:,1:32,:,:)))));
f_band = [10 100];
nhigh = find(Axis.frequency<f_band(2),1,'last');
nlow = find(Axis.frequency>f_band(1),1);
t = find(Axis.time>-1000,1):find(Axis.time<1000,1,'last');
%%
subplot(211)
imagesc(Axis.time(t),Axis.frequency(1:nhigh),...
    (diff(x(1:nhigh,t),[],2)))
% imagesc(Axis.time(t),Axis.frequency(2:nhigh),10*log10(x(2:nhigh,t)))
axis xy
% ylim([0,40])
colorbar 
title('Slope of LFP Power / Frequency Band','fontsize',18)
%%
subplot(212)
low = mean(x(2:nlow,t));
high = mean(x(nlow:nhigh,t));
plotyy(Axis.time(t),low,Axis.time(t),high);
legend({sprintf('%2i~%2i Hz',0,f_band(1)),sprintf('%2i~%2i Hz',f_band(1),f_band(2))})

% %%
% plot(Axis.time,normalize(x(1:nhigh,:),2));
% % legend(num2str(Axis.frequency(1:nhigh)),'location','eastoutside')
% % plot(Axis.time,x(:,2:n-1));
% 
% title('Average LFP Power','fontsize',18)
% xlabel('Time w.r.t. movement onset (ms)','fontsize',14)
