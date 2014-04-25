function S = extract_psd(lfp)

S = zeros(size(lfp));

for i = 1:size(lfp,1)
    for j = 1:size(lfp,2)
        S(i,j,:) = pmtm(lfp(i,j,:));
    end
end