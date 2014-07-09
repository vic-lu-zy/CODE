% close all
x = abs(squeeze(mean(mean(Spect))));
nhigh = find(Axis.frequency<40,1,'last');
nlow = find(Axis.frequency>10,1);
t = find(Axis.time>-500,1):find(Axis.time<500,1,'last');
%%
subplot(211)
imagesc(Axis.time(t)+.8,Axis.frequency(1:nhigh),diff(x(1:nhigh,t)))
axis xy
% ylim([0,40])
colorbar 
title('Slope of LFP Power / Frequency Band','fontsize',18)
%%
subplot(212)
low = mean(x(2:nlow,t));
high = mean(x(nlow:nhigh,t));
% plot(Axis.time(t),low,Axis.time(t),high);
% legend({'0~10 Hz','10~40 Hz'})
% axis tight
% 
plot(Axis.time,normalize(x(1:nhigh,:),2));
legend(num2str(Axis.frequency(1:nhigh)),'location','eastoutside')
% plot(Axis.time,x(:,2:n-1));

title('Average LFP Power','fontsize',18)
xlabel('Time w.r.t. movement onset (ms)','fontsize',14)
