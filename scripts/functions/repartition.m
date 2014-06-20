function part = repartition(cl,mode)

u = unique(cl);
h = hist(cl,length(u));

if strcmp(mode,'min')
    n = min(h);
    part = zeros(n,length(u));
    for i = 1:length(u)
        part(:,i)=randsample(find(cl==u(i)),n);
    end
elseif strcmp(mode,'max')
    [n,k] = max(h);
    part = zeros(n,length(u));
    for i = 1:length(u)
        ind = find(cl==u(i));
        temp = repmat(ind,ceil(h(k)/h(i)));
        part(:,i) = temp(1:n);
    end
end
part = part(:);