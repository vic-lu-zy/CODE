[S,freq] = pmtm(x,2.5,256,1000);
fspace = logspace(0,log10(500),20); 
fspace(1)=0;

[~, binidx] = histc(freq,fspace);

binidx(end)=binidx(end-1);

means = accumarray(binidx, S, [], @mean);

loglog(freq,S,fspace(1:end-1),means)
