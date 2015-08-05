tasks = [2 5];
todo = 0;

numcolor = 5;
for n = 1:2
    if todo
        [Spect{n},Axis{n}] = ...
            extract_spectrogram_chronux(...
            LFP{tasks(n)},task_timing{tasks(n)},[.3 .03],[1 1]);
    end
    for arr = 1:2
        C = zeros(length(Axis{n}.time)*length(Axis{n}.freq),1);
        subplot(2,3,(n-1)*3+arr)
        for ii = (arr-1)*16+(1:16)
            [X,Y] = getXY(Spect{n}(ii,:,:,:),cl{n},[1 3],0);
            C = C + corr(X,Y)/16;
            %         [~,Z] = rankfeatures(X',Y);
            %         C = C + Z;
        end
        Z = reshape(C.^2,[],length(Axis{n}.freq))';
        [~,h] = contourf(Axis{n}.time*1e3,...
            Axis{n}.freq,Z,numcolor); axis xy
        caxis(minmax(h.LevelList))
        colormap(jet(numcolor))
        c = colorbar;
        h = h.LevelList;
        ran = range(h);
        c.Ticks = linspace(min(h)+.5/numcolor*ran,max(h)-.5/numcolor*ran,numcolor);
        c.TickLabels = ['01234']';
        %     ran = range(Z(:));
        %     c.Ticks = linspace(min(Z(:))+.5/numcolor*ran,max(Z(:))-.5/numcolor*ran,numcolor);
        c.FontSize = 16;
    end
end