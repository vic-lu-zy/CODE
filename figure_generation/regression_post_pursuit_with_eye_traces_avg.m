clf
hold on
rectangle('Position',[-.5 0 .5 20],'facecolor','g')
text(-.2,18,'pre-pursuit')
rectangle('Position',[0 0 1.25 20],'facecolor','y')
text(.5,18,'during-pursuit')
rectangle('Position',[1.25 0 .75 20],'facecolor','r')
text(1.5,18,'during-reach')

subplot 121
hold on
rectangle('Position',[-.5 0 .5 20],'facecolor','g')
text(-.2,18,'pre-pursuit')
rectangle('Position',[0 0 1.25 20],'facecolor','y')
text(.5,18,'during-pursuit')
rectangle('Position',[1.25 0 .75 20],'facecolor','r')
text(1.5,18,'during-reach')
S = squeeze(mean(median(mean(Spect{3}(:,:,1:80,1:6),4))));
z = abs(Eye_x+i*Eye_y);
[ax,h1,h2] = plotyy(t,mean(z,2),Axis{3}.time,S);
set(ax(1),'xlim',[-.2 2],'ylim',[0 12])
set(ax(2),'xlim',[-.2 2],'ylim',[1 4]*1e-5)
set(h1,'linewidth',3)
set(h2,'linewidth',3)

xlabel('time w.r.t. pursuit onset (s)')
title('Low Freq (0~10) Hz','fontsize',14)

subplot 122
hold on
rectangle('Position',[-.5 0 .5 20],'facecolor','g')
text(-.2,18,'pre-pursuit')
rectangle('Position',[0 0 1.25 20],'facecolor','y')
text(.5,18,'during-pursuit')
rectangle('Position',[1.25 0 .75 20],'facecolor','r')
text(1.5,18,'during-reach')
S = squeeze(mean(median(mean(Spect{3}(:,:,1:80,12:17),4))));
z = abs(Eye_x+i*Eye_y);
[ax,h1,h2] = plotyy(t,mean(z,2),Axis{3}.time,S);
set(ax(1),'xlim',[-.2 2],'ylim',[0 12])
set(ax(2),'xlim',[-.2 2])
set(h1,'linewidth',3)
set(h2,'linewidth',3)

xlabel('time w.r.t. pursuit onset (s)')
title('Mid Freq (20~30) Hz','fontsize',14)