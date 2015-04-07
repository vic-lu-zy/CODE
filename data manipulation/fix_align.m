load Eye_traces
z = abs(Eye.x+j*Eye.y);
for ii = 1:length(trials)
subplot(6,20,ii)
T67_start(ii) = find(z(trials(ii),1:2000)>2.5,1,'last')+5;
T67_end(ii) = find(z(trials(ii),4000:8000)>2.5,1)+3995;
plot(T67_start(ii):T67_end(ii),...
    z(trials(ii),T67_start(ii):T67_end(ii)))
axis off tight
end