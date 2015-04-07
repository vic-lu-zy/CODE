ccc

%% extract saccade using probe
load RecordingVariables
T = Events.T.T65sac;
I = find(~isnan(T)); % index of saccade
T = T(I)+1000; % start time of saccade

n = length(T);
t = -50:100;

x65 = zeros(n,length(t));
y65 = x65;

for i = 1:length(T)
    x65(i,:) = Eye.x(I(i),t+T(i));
    y65(i,:) = Eye.y(I(i),t+T(i));
end

mag65 = sqrt(x65.^2+y65.^2)';
mag65 = mag65 - repmat(mean(mag65(1:40,:)),length(t),1);
mag65 = mag65./ repmat(mean(mag65(end-40:end,:)),length(t),1);

%% extract saccade with line fit
ft = fittype('myPiecewise(x,t1,t2)');
opt = fitoptions(ft);
opt.StartPoint = [1 2];
opt.Lower = [-10 10];
n = size(mag65,2);
T65 = zeros(n,2);

for ii = 1:n
    f = fit( t' , mag65(:,ii) , ft, opt);
    T65(ii,1) = f.t1;
    T65(ii,2) = f.t2;
end

%%
T65sac = round(T65(:,1))+T-1000;
T = nan(size(Events.T.T65sac));
T(I) = T65sac;
T65sac = T;

save('T65sac','T65sac')