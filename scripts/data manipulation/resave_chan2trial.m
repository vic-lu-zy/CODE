% cd 'D:\NPL_DATA\M20140412_245';

cd ~/gs/

f = fopen('xfer_progress.txt','w');
for ii = 1:413
    eval(sprintf('S_trial_%02i=zeros(48,129,938,''single'');',ii));
    for jj = 1:48
        fprintf(f,'ii = %02i, jj = %02i\n',ii,jj);
        load(sprintf('psd_by_electrode_reach/LFPChan%02i',jj))
        eval(sprintf('S_trial_%02i(%i,:,:) = S(%i,:,:);',ii,jj,ii));
    end
    eval(sprintf('save(''Spect_by_trial_Reach'',''S_trial_%02i'',''-append'')',ii))
    eval(sprintf('clear(''S_trial_%02i'')',ii))
%     waitbar(ii/177,w)
end
% close(w)
close(f)