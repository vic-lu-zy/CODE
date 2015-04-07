clf

c = zeros(80);

TT = T(1:30:end);
ez = mean(abs(ex+1i*ey),2);
x = ez(1:30:end);

for ii = 1:79
    for jj = ii+1:80
        c(ii,jj) = corr(x(ii:jj),S(ii:jj))*log(jj-ii);
    end
end

%%
subplot 121
imagesc(TT,TT,c')
axis image xy
grid
colorbar
%%
subplot 122
plot(TT,x/max(x),TT,S/max(S));
axis square
grid