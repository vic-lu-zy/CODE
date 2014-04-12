T = Events.T.T65sac;
I = find(~isnan(T)); % index of saccade
T = T(I)+1000; % start time of saccade

n = length(T);
t = -200:600;

x65 = zeros(n,length(t));
y65 = x65;


for i = 1:length(T)
    x65(i,:) = Eye.x(I(i),t+T(i));
    y65(i,:) = Eye.y(I(i),t+T(i));
end

subplot 221
plot(Eye.T/1000,Eye.x(I,:)'); axis tight
title('pre-alignment x')
xlabel('time (s)')
subplot 222
plot(Eye.T/1000,Eye.y(I,:)'); axis tight
title('pre-alignment y')
xlabel('time (s)')
subplot 223
plot(t/1000,x65'); axis tight
title('post alignment x')
xlabel('time (s)')

subplot 224
plot(t/1000,y65'); axis tight
title('post alignment y')
xlabel('time (s)')