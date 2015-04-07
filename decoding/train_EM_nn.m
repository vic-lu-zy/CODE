
T = T65sac + randi(100,size(T65sac))-50;
eyex65 = extract_time_range(Eye.x,T+1000,-50:99);
eyey65 = extract_time_range(Eye.x,T+1000,-50:99);

T = T66on + randi(100,size(T66on))-50;
eyex66 = extract_time_range(Eye.x,T+1000,-50:99);
eyey66 = extract_time_range(Eye.x,T+1000,-50:99);

T = T67 + randi(100,size(T67))-50;
eyex67 = extract_time_range(Eye.x,T+1000,-50:99);
eyey67 = extract_time_range(Eye.x,T+1000,-50:99);

X = [eyex65' eyey65'; eyex66' eyey66'; eyex67' eyey67'];

%%
load('cl65')
cl65 = cl;
load('cl66')
cl66 = cl;
Y = label2array([cl65; cl66+4; 9*ones(58,1)]);

%%
reshuffled = randsample(413,413);
X = X(reshuffled,:);
Y = Y(reshuffled,:);