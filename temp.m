trials = find(~isnan(T65sac));

f = figure;

dir = 'C:/Users/vic/Google Drive/Thesis/figures/20100412/Saccade/';

for ii = 121:length(trials)
    for jj = 1:48
        subplot 211
        plot(-500:500,Eye_x(:,ii),-500:500,Eye_y(:,ii));
        
        subplot 212
        imagesc(Axis.time,Axis.frequency,...
            squeeze(Spect(ii,jj,:,:))'...
            .*repmat(1:52,size(Spect,3),1)');
        axis xy off
        
        print(f,sprintf([dir 'Trial_#%03i_%02i'],...
            trials(ii),jj),'-dpng');
    end
end