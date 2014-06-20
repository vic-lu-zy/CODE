subplot 121
plot(LFP(40,1000:6000))
rectangle('position',[t-50 -.06 300 .15],'edgecolor','r','linewidth',4)
axis tight
title('LFP Time Series','fontsize',20)
ylabel('LFP (V)','fontsize',18)
xlabel('Time (ms)','fontsize',18)

subplot 122
Pxx = pmtm(LFP(40,t+1000+(0:256)));
F = linspace(0,500,257);
plot(F(2:find(F>50,1)),Pxx(2:find(F>50,1)),'linewidth',2)
title('Power Spectrum Density','fontsize',20)
ylabel('Power (V/Hz)','fontsize',18)
xlabel('Frequency (Hz)','fontsize',18)
axis tight