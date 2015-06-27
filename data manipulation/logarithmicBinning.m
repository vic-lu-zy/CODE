freq = Axis{2}.frequency(:);

fspace = logspace(0,log10(500),20)';
fspace(1)=0;

[~, binidx] = histc(freq,fspace);
binidx(~binidx) = binidx(find(~binidx)-1);
n = max(binidx);

ss = size(S);
means = zeros([ss(1:3),n]);

tic
for ii = 1:n
    if any(binidx==ii)
        means(:,:,:,ii) = mean(S(:,:,:,binidx==ii),4);
    end
end
toc
