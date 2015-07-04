% decoding rate vs (time,freq)

data = SpectBinned{2};

timeN = size(data,3);
freqN = size(data,4);
direction = [1 3];

h = hist(cl,4);
trials = [];
n = min(h(direction));
for ii = direction
    trials = [trials; randsample(find(cl==ii),n)];
end

% random permutate the trials
ind = randperm(length(trials),length(trials));
trials = trials(ind);

X = data(1,trials,:,:);
X = normalize2d(X,2);
X = permute(X,[2 1 3 4]);
Y = cl(trials);

%%
[start,finish] = meshgrid(1:timeN);
valid = finish >= start;
start = start(valid);
finish = finish(valid);
thisRate = start;
parfor ii = 1:length(start)
        thisX = reshape(X(:,:,start(ii):finish(ii),:),size(X,1),[]);
        thisRate(ii) = svm_classify(thisX,Y);
end
rate.time = nan(timeN);
rate.time((start-1)*timeN+finish) = thisRate;
%%
rate.freq = nan(freqN);
fig = imagesc(Axis{2}.freq,Axis{2}.freq,rate.freq); axis xy, colorbar
for freqStart = 1:freqN
    for freqEnd = freqStart:freqN
        thisX = reshape(X(:,:,13:29,freqStart:freqEnd),size(X,1),[]);
        rate.freq(freqStart,freqEnd) = svm_classify(thisX,Y);
        fig.CData = rate.freq;
        drawnow
    end
end