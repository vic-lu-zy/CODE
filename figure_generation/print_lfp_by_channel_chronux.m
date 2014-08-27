params.Fs = 1000;
params.tapers = [2 3];
params.fpass = [0 50];
movingwin = [.3 .03];

%%
path_out = 'C:/Users/vic/Dropbox/thesis/figures/20100412/Spect/Saccade/';
load('LFP_ALL_IN_ONE','LFP_ALL_IN_ONE_SACCADE')
LFP_ALL_IN_ONE_SACCADE = double(LFP_ALL_IN_ONE_SACCADE)*1000;
load cl65
% 
% path_out = 'C:/Users/vic/Dropbox/thesis/figures/20100412/Spect/Reach/';
% load('LFP_ALL_IN_ONE','LFP_ALL_IN_ONE_REACH')
% LFP_ALL_IN_ONE_REACH = double(LFP_ALL_IN_ONE_REACH);
% load cl_hand
% cl = h;

for ii = 1:4
    numb_trials(ii) = sum(cl==ii);
end
%%
f = figure(1);
for ii = 1:48
    figure(f)
    for jj = 1:4
        subplot(2,2,jj)
        lfp = squeeze(LFP_ALL_IN_ONE_SACCADE(ii,cl==jj,:));
        [P,T,F] = mtspecgramc(lfp(1,:),movingwin,params);
        for nn = 2:numb_trials(jj)
            P = P + mtspecgramc(lfp(nn,:),movingwin,params);
        end
        imagesc(T-.5,F,10*log10(P'/numb_trials(jj)),[0 25])
        colorbar
        title(sprintf('Dir=%i',jj))
        axis xy
    end
    print(f,sprintf([path_out '%02i'],ii),'-dpng')
end
