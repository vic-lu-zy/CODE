% w = waitbar(0,'Calculating');
dir = {'Right','Up','Left','Down'};
tic
parfor elec = 1:48
    %     waitbar(elec/48,w,sprintf('%4.2f %%',elec/48*100));
    h = figure('paperposition',[0 0 16 12]);
    
    %%
    [S65,T65,F65] = lfp_spect(elec,65,h);
    
    print(h,'-dpng',['D:\Documents\Dropbox\thesis\figures\Spect\Spect - Sac - E' num2str(elec) '.png'])
    
    [S66,T66,F66] = lfp_spect(elec,66,h);
    
    print(h,'-dpng',['D:\Documents\Dropbox\thesis\figures\Spect\Spect - Pur - E' num2str(elec) '.png'])
    
    [S8,T8,F8] = lfp_spect(elec,8,h);
    
    print(h,'-dpng',['D:\Documents\Dropbox\thesis\figures\Spect\Spect - Fix - E' num2str(elec) '.png'])
    
    close(h)
end
toc
% close(w)