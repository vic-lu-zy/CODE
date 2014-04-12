T = Events.T.T8;

L = length(T);
t = 500:2500;
x8 = zeros(L,length(t));
y8 = x8;


for i = 1:length(T)
    x8(i,:) = Hand.x(i,t+T(i));
    y8(i,:) = Hand.y(i,t+T(i));
end

x8(x8<-10) = nan;
y8(y8<-10) = nan;

subplot 221
plot(Hand.x');
title('pre-alignment x')

subplot 222
plot(Hand.y');
title('pre-alignment y')

subplot 223
plot(x8');
title('post alignment x')
axis tight

subplot 224
plot(y8');
title('post alignment y')
axis tight