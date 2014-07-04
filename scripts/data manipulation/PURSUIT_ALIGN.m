T = Events.T.T66on;
I = find(~isnan(T)); % index of saccade
T = T(I); % start time of saccade

X = Eye.x(I,:); X(X>7 | X<-15)=nan;
Y = Eye.y(I,:); Y(Y>16 | Y<-9)=nan;

L = length(T);
t = 600:3000;
x66 = zeros(L,length(t));
y66 = x66;


for i = 1:L
    x66(i,:) = X(i,t+T(i));
    y66(i,:) = Y(i,t+T(i));
end

subplot 221
plot(X');
title('pre-alignment x')
axis tight

subplot 222
plot(Y');
title('pre-alignment y')
axis tight

subplot 223
plot((t-1000)/1000,x66');
title('post alignment x')
axis tight

subplot 224
plot((t-1000)/1000,y66');
title('post alignment y')
axis tight
