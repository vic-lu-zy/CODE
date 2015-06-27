% function extract_spectrogram_chronux

%%
% to_do = [2 3 4 5]; %2 = sac, 3 = pur, 4 = fix, 5 = reach
to_do = 3:5

params.Fs = 1000;
params.tapers = [2 3];
params.fpass = [0 500];
movingwin = [.3 .03];

fspace = logspace(0,log10(500),20)';
fspace(1)=0;

for task = to_do
    
    lfp = LFP{task};
    
    lfp = reshape(lfp,[],size(lfp,3));
    
    [~,Axis{task}.time,Axis{task}.freq] = ...
        mtspecgramc(lfp(1,:),movingwin,params);
    
    Axis{task}.time = Axis{task}.time+(task_timing{task}(1)/1000);
    %%
    tic
    S = single(mtspecgramc(lfp',movingwin,params));
    toc
    
    S = reshape(S,size(S,1),size(S,2),48,[]);
    S = permute(S,[3 4 1 2]);
    Spect{task} = S;
    
    [~, binidx] = histc(Axis{task}.freq(:),fspace);
    binidx(~binidx) = binidx(find(~binidx)-1);
    n = max(binidx);
    
    ss = size(S);
    logBins = zeros([ss(1:3),n]);
    
    
    for ii = 1:n
        if any(binidx==ii)
            logBins(:,:,:,ii) = mean(S(:,:,:,binidx==ii),4);
        end
    end
    
    Axis{task}.freq = fspace(logBins(1,1,1,:)>0);
    logBins(:,:,:,~logBins(1,1,1,:))=[]; % removes zero'd dimensions
    
    SpectBinned{task} = logBins;
end
