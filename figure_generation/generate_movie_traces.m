close all

n = 1000;

h = plot3(lfp1(1:n),lfp2(1:n),lfp3(1:n),'b-',...
    lfp1(n),lfp2(n),lfp3(n),'ro');

xlim(30*[-1 1]),ylim(30*[-1 1]),zlim(.5*[-1 1]);

grid minor

for ii = 1:length(eyex)-n
    set(h(1),'XData',lfp1(ii:ii+n-1));
    set(h(1),'YData',lfp2(ii:ii+n-1));
    set(h(1),'ZData',lfp3(ii:ii+n-1));
    set(h(2),'XData',lfp1(ii+n-1));
    set(h(2),'YData',lfp2(ii+n-1));
    set(h(2),'ZData',lfp3(ii+n-1));
    drawnow
end