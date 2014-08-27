function [Sd, T, F] = lfp_spect(electrode,EM,fig)

narginchk(3,3);

% pursuit #66
% saccade #65

if electrode < 1 || electrode > 48
    error('no such electode')
else
    load(sprintf('LFPChan%1d',electrode));
end

load cl_eye
load cl_hand

switch(EM)
    case 65
        load('T65sac.mat');
        T = T65sac-LFP.T(1);
        tt = -10:50;
        len = (0:256);
    case 66
        load('T66on.mat');
        T = T66on-LFP.T(1);
        tt = -10:50;
        len = (0:256);
    case 8
        load('T8.mat');
        T = T8;
        tt = -30:10;
        len = -256:0;
end

I = find(~isnan(T));

T = T(I);

nTrial = length(T);

lfp = zeros(nTrial,length(tt),257); %2^8+1 = 257

for i = 1:nTrial
    for j = 1:length(tt)
        lfp(i,j,:) = LFP.AD(I(i),T(i)+tt(j)*20+len);
    end
end

%%
Spect = zeros(size(lfp));

% w = waitbar(0,'Calculating PMTM');
% tic
for i = 1:nTrial
    %     waitbar(i/nTrial,w,sprintf('%4.2f %%',i/nTrial*100));
    for j = 1:size(lfp,2)
        Spect(i,j,:) = pmtm(lfp(i,j,:));
    end
end
[~,ff]=pmtm(lfp(1,1,:));
% toc
% close(w)

%%
% ff is normalized from 0 to pi. To recover freq, do: ff * fs / (2 pi)
frange = 2:30;
F = ff(frange)*500/pi;
T = tt*20;

if EM == 8
    Sd = squeeze(mean(Spect(:,:,frange)));
    figure(fig)
    subplot 111
    imagesc(T,F,Sd');
    axis tight
    axis xy
    colorbar
    xlabel('time (ms)')
    ylabel('Freq (Hz)')
else
    Sd = zeros(4,4,length(T),length(F));
    for i = 1:4
        for j = 1:4
            Sd(i,j,:,:) = squeeze(mean(Spect(cl(I)==i & h(I)==j,:,frange)));
            
            
            figure(fig)
            subplot(4,4,(j-1)*4+i)
            imagesc(T,F,squeeze(Sd(i,j,:,:))');
            axis tight
            axis xy
            caxis([0 max(Sd(:))*.95])
            %                 colorbar
            title(sprintf('eye = %i, hand = %i',i,j))
            xlabel('time (ms)')
            ylabel('Freq (Hz)')
            
        end
    end
end