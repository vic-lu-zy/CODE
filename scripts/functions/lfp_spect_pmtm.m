function [S,F,T] = lfp_spect_pmtm(x,NW,step)

T = 0:step:(length(x)-NW);
F = linspace(0,500,NW);

S = zeros(length(T),NW);

for i = 1:length(T)
    S(i,:) = pmtm(x(T(i)+(1:NW)))';
end