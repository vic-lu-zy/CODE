load Eye_traces
z = abs(Eye.x+j*Eye.y);
for ii = 1:58
subplot(6,10,ii)
T67_start(ii) = find(z(ii,1:2000)>2.5,1,'last')+5;
T67_end(ii) = find(z(ii,4000:8000)>2.5,1)+3995;
plot(i1(ii):i2(ii),z(ii,i1(ii):i2(ii)))
axis off tight
end