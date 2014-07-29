f = figure(1);
dir = 'C:/Users/vic/Google Drive/Thesis/figures/20100412/Saccade/';

% nTime1 = find(Axis.time>-500,1)-1;
nTime1 = 1;
% nTime2 = find(Axis.time>500,1);
nTime2 = length(Axis.time);

% nFreq = find(Axis.frequency>80,1);
% nFreq1 = find(Axis.frequency>15,1);
% nFreq2 = find(Axis.frequency>30,1);
% nFreq3 = find(Axis.frequency>50,1);

nFreq = length(Axis.frequency);
nFreq1 = find(Axis.frequency>20,1);
nFreq2 = find(Axis.frequency>60,1);
% nFreq3 = find(Axis.frequency>50,1);

for ii = 1:48
    figure(f)
    %%
    for jj = 1:4
        
        subplot(4,2,2*jj-1)
        
        SS = squeeze(median((Spect(cl==jj,ii,nTime1:nTime2,1:nFreq))))'...
            .*repmat(1:nFreq,nTime2-nTime1+1,1)';
        imagesc(Axis.time(nTime1:nTime2),Axis.frequency(1:nFreq),SS);
        axis xy
        
        subplot(4,2,2*jj)
        low = mean(SS(nFreq1:nFreq2-1,:));
%         high = mean(SS(nFreq2:nFreq3,:));
        high = low;
        
        plot(Axis.time(nTime1:nTime2),low,Axis.time(nTime1:nTime2),high,'linewidth',2)
                
        axis tight
    end
    print(f,sprintf([dir 'By_Channel_64ms/Channel_#%02i'],ii),'-dpng');
end