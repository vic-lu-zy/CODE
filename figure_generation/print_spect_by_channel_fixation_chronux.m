params.Fs = 1000;
params.tapers = [2 3];
params.fpass = [0 50];
movingwin = [.3 .03];

%%
path_out = 'C:/Users/vic/Dropbox/thesis/figures/20100412/Spect/Fixation/';
% load('LFP_ALL_IN_ONE','LFP_ALL_IN_ONE_FIXATION')
LFP_ALL_IN_ONE_FIXATION = double(LFP_ALL_IN_ONE_FIXATION)*1e3;
numb_trials = size(LFP_ALL_IN_ONE_FIXATION,2);
%%
f = figure(1);
for ii = 1:48
    figure(f)
    lfp = squeeze(LFP_ALL_IN_ONE_FIXATION(ii,:,:));
    [P,T,F] = mtspecgramc(lfp(1,:),movingwin,params);
    for nn = 2:numb_trials
        P = P + mtspecgramc(lfp(nn,:),movingwin,params);
    end
    imagesc(T-2,F,10*log10(P'/numb_trials),[0 25])
    colorbar
    %         title(sprintf('Dir=%i',jj))
    axis xy
    print(f,sprintf([path_out '%02i'],ii),'-dpng')
end
