sel = [];
for ii = 1:58
    plot(-50:199,eyex67(:,ii),-50:199,eyey67(:,ii))
    s = input('','s');
    if s=='y'
        sel = [sel ii];
    end
end
%%
for ii = 1:25
    subplot(5,5,ii)
    plot(-50:199,eyex67(:,sel(ii)),-50:199,eyey67(:,sel(ii)))
end