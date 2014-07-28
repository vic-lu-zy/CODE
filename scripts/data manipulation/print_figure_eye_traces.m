ind = find(~isnan(T66on));

f = figure(1); 

for i = 1:8
    for j = 1:20
        subplot(4,5,j)
        plot(z(:,(i-1)*20+j))
        axis tight
        axis off
        title(num2str(ind((i-1)*20+j)),'fontsize',16)
    end
    print(f,['C:\Users\vic\Google Drive\Thesis\figures\20100407\' num2str(i)],'-dpng')
end

close(f)