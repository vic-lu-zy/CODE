trials = find(~isnan(T65sac));

f = figure(1);

dir = 'C:/Users/vic/Google Drive/Thesis/figures/20100412/Saccade/';

n1 = find(Axis.time>-100,1)-1;
n2 = find(Axis.time>100,1);

for ii = 1:length(trials)
    
    for jj = 0:3
    figure(f);    
        if ~jj
            subplot 111
            plot(-500:500,Eye_x(:,ii), ...
                -500:500,Eye_y(:,ii),'linewidth',4)
        else
            for kk = 1:16
                
                %%
                subplot(4,4,kk)
                imagesc(Axis.time(n1:n2),Axis.frequency,...
                    squeeze(Spect(ii,(jj-1)*16+kk,n1:n2,:))'...
                    .*repmat(1:52,n2-n1+1,1)');
                axis xy off
                title(sprintf('Channel #%02i',(jj-1)*16+kk))
            end
        end
        
        print(f,sprintf([dir num2str(cl(ii)) '/Trial_#%03i_%i'],...
            trials(ii),jj),'-dpng');
    end
end

close(f)