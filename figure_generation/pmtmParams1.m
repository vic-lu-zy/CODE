% ww = (.05:.05:.5);
% mw = (1:5)/100;

ww = linspace(.25,.45,21);
mw = linspace(.01,.03,21);

% rate = zeros(4);
for ii = 1:length(ww)
    for jj = 1:length(mw)
        movingwin = [ww(ii) mw(jj)];
        [logBins, Axis] = ...
            extract_spectrogram_chronux(lfp,task_timing,movingwin);
        t1 = find(Axis.time>-.1,1);
        t2 = find(Axis.time>.3,1)-1;
        [X,Y] = getXY(logBins(1,:,t1:t2,:),cl,[1,3],0);
        rate(ii,jj) = svm_classify(X,Y);
    end
end