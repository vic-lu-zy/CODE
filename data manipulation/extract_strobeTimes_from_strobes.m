% extract_strobeTimes_from_strobes
clear
clc

load Events
S = Events.strobes;
ST = Events.strobeTimes;
[m,n] = size(S);

load lfpxeye
eyex = LFP.AD;
load lfpyeye
eyey = LFP.AD;
load lfpxhand
handx = LFP.AD;
handx(handx<-15)=nan;
load lfpyhand
handy = LFP.AD;
handy(handy<-15)=nan;

%% saccade
[ii,jj] = find(S==65);
T65sac = nan(m,1);
T65sac(ii) = ST((jj-1)*m+ii);
for ii = 1:m
    if ~isnan(T65sac(ii))
        T = myFindSaccade(eyex(ii,:),eyey(ii,:),T65sac(ii));
        T65sac(ii) = T(1);
    end
end
tt = -500:1500;
xx = extract_time_range(eyex,T65sac+1000,tt);
yy = extract_time_range(eyey,T65sac+1000,tt);

% classify
cl = zeros(sum(~isnan(T65sac)),1);
cl(any(xx>5)) = 1; %right
cl(any(xx<-5)) = 3; %left
cl(any(yy>8)) = 2; %top
cl(any(yy<4)) = 4; %bottom
for ii = 1:sum(~isnan(T65sac))
plot(xx(:,ii),yy(:,ii),'Color',colordg(cl(ii))), hold on
end
save('T65sac','T65sac')
save('cl65','cl')
%% pursuit
T66on = nan(m,1);
for ii = 1:m
    if any(S(ii,:)==66);
        [~,jj] = find(S(ii,:)==66,1);
        T66on(ii) = ST(ii,jj)+1000;
    end
end
xx = extract_time_range(eyex,T66on+1000,tt);
yy = extract_time_range(eyey,T66on+1000,tt);
% plot(tt,xx,'r',tt,yy,'b')
% plot(xx,yy,'.'),grid
cl = zeros(sum(~isnan(T66on)),1);
cl(any(xx>5)) = 1; %right
cl(any(xx<-5)) = 3; %left
cl(any(yy>8)) = 2; %top
cl(any(yy<4)) = 4; %bottom
for ii = 1:sum(~isnan(T66on))
plot(xx(:,ii),yy(:,ii),'Color',colordg(cl(ii))), hold on
end
save('T66on','T66on')
save('cl66','cl')
%% fixation
T67 = nan(m,1);
ind = find(S(:,22)==67);
T67(ind) = 1500;
xx = extract_time_range(eyex,T67+1000,tt);
yy = extract_time_range(eyey,T67+1000,tt);
unstable = find(any(xx>5) | any(xx<-1.5) | any(yy>6.75) | any(yy<4));
T67(ind(unstable)) = nan;
xx = extract_time_range(eyex,T67+1000,tt);
yy = extract_time_range(eyey,T67+1000,tt);

plot(tt,xx,'r',tt,yy,'b')
save('T67','T67')

%% reach
Treach = sum(ST'.*(S==8)')';
xx = extract_time_range(handx,Treach+1000,tt);
% yy = extract_time_range(handy,Treach+1000,tt);
for ii = 1:m
    n = find(isnan(xx(:,ii)),1);
    Treach(ii) = Treach(ii)-500+n;
end
xx = extract_time_range(handx,Treach+1000,tt);
xx = xx - repmat(mean(xx(1:400,:)),size(xx,1),1);
yy = extract_time_range(handy,Treach+1000,tt);
yy = yy - repmat(mean(yy(1:400,:)),size(yy,1),1);
% plot(tt,xx,'r',tt,yy,'b')

cl = zeros(m,1);
cl(any(xx>2)) = 1; %right
cl(any(xx<-3)) = 3; %left
cl(any(yy>7)) = 2; %top
cl(yy(end,:)<-2 & xx(end,:)>-2 & xx(end,:)<2) = 4; %bottom
for ii = 1:m
plot(xx(:,ii),yy(:,ii),'Color',colordg(cl(ii))), hold on
end
save('Treach','Treach')
save('cl_hand','cl')