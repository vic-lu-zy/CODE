function [S,F,T] = lfp_spect_pmtm(x,window,step,nfft)

T = 0:step:(length(x)-window);
F = linspace(0,500,nfft/2+1);

S = zeros(length(T),length(F));

for i = 1:length(T)
    S(i,:) = pmtm(x(T(i)+(1:window)),[],nfft);
end

T = T+window/2;
%% parallel
% [xx,yy]=meshgrid(0:NW-1,T);
% ind = xx + yy + 1;
% 
% S = x(ind);
% 
% parfor i = 1:length(T)
%     S(i,:) = pmtm(S(i,:));
% end