%% remove bad traces
x = x - repmat(x(1,:),size(x,1),1);
x = x ./ repmat(mean(x(end-50:end,:)),size(x,1),1);
y = y - repmat(y(1,:),size(y,1),1);
y = y ./ repmat(mean(y(end-50:end,:)),size(y,1),1);
f = figure;
indh = find(n==1 | n==3); indv = find(n==2 | n==4);
xh = x(:,indh); yv = y(:,indv);
plot(xh), ylim([-.5 1.5])
drawnow
rect = getrect(f);
badtraces = ...
    indh(find(any(xh(round(rect(1))+(0:round(rect(3))),:)>rect(2) & ...
    xh(round(rect(1))+(0:round(rect(3))),:)<rect(4))));
plot(yv), ylim([-.5 1.5])
drawnow
rect = getrect(f);
badtraces = [badtraces; ...
    indv(find(any(yv(round(rect(1))+(0:round(rect(3))),:)>rect(2) & ...
    yv(round(rect(1))+(0:round(rect(3))),:)<rect(4))))];
close(f)
x(:,badtraces)=[];
y(:,badtraces)=[];
n(badtraces)=[];

subplot 211, plot(x(:,n==1 | n==3))
subplot 212, plot(y(:,n==2 | n==4))