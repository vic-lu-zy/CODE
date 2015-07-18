% decoding rate vs (time,freq)

% data = SpectBinned{2};
[logBins, ~ , Axis] = ...
    extract_spectrogram_chronux(lfp,task_timing,[.3 .03],[1 1]);

timeN = size(logBins,3);
freqN = size(logBins,4);
direction = [1 3];

[X,Y] = getXY(logBins(1,:,:,:),cl,[1 3],0);

%%
[start,finish] = meshgrid(1:timeN);
valid = finish >= start;
start = start(valid);
finish = finish(valid);
thisRate = nan(size(start));

for ii = 1:length(start)
%     thisX = reshape(X(:,:,start(ii):finish(ii),:),size(X,1),[]);
    [thisX,~] = getXY(logBins(1,:,start(ii):finish(ii),:),cl,direction,0);
    thisRate(ii) = svm_classify(thisX,Y);
    waitbar(ii/length(start))
end

rate.time = nan(timeN);
rate.time((start-1)*timeN+finish) = thisRate;

%%

[start,finish] = meshgrid(1:freqN);
valid = finish >= start;
start = start(valid);
finish = finish(valid);
thisRate = nan(size(start));
t1 = find(Axis.time>-.1,1);
t2 = find(Axis.time>.3,1)-1;

for ii = 1:length(start)
%     thisX = reshape(X(:,:,start(ii):finish(ii),:),size(X,1),[]);
    [thisX,~] = getXY(logBins(1,:,t1:t2,start(ii):finish(ii)),cl,direction,0);
    thisRate(ii) = svm_classify(thisX,Y);
    waitbar(ii/length(start))
end

rate.freq = nan(timeN);
rate.freq((start-1)*timeN+finish) = thisRate;

%%
subplot 121
imagesc(Axis.time,Axis.time,rate.time)
axis image xy
colorbar
subplot 122
imagesc(Axis.freq,Axis.freq,rate.freq)
axis image xy
colorbar