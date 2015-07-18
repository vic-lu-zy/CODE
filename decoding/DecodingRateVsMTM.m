widthrange = .1:.05:.5;
steprange = .01:.01:.1;
tapers = 1:9;
[width,step] = ndgrid(widthrange,steprange);
%%
% rate = zeros(size(TAPERS));

n = numel(width);

% rateReach2 = cell(size(tapers));

for tap = 1
    
    rate = zeros(size(width));
    
    fprintf('Progress:\n');
    fprintf(['\n' repmat('.',1,n) '\n\n']);
    tic
    parfor jj = 1:n
        
        logBins = extract_spectrogram_chronux(...
            lfp,task_timing,[width(jj) step(jj)],tap*[1 2]-[0 1]);
        
        [X,Y] = getXY(logBins(1,:,:,:),cl,[1,3],0);
        
        rate(jj) = svm_classify(X,Y);
        fprintf('\b|\n');
        
        %     waitbar(ii/n)
    end
    toc
    
    rateReach2{tap} = rate;
    
    subplot(3,3,tap)
    imagesc(steprange,widthrange,rateReach2{tap})
    %     caxis(minmax(rate(:)'))
    title(sprintf('#Tapers = %i',tap))
    drawnow
end

%%
for ii = tapers
    subplot(3,3,ii)
    imagesc(steprange,widthrange,rateReach2{ii})
    colorbar
    title(sprintf('#Tapers = %i',ii))
end