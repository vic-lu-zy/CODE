ccc
load SPECT_ALL_IN_ONE
load T65sac
load cl65

%% construct feature space
% with all chan and all freq
% ind = find(~isnan(T65sac));
[X,Y] = getXY(Spect,cl,dir);

%%
Y = vec();
% Y = label2array(Y);