function x = extract_time_range(DATA,T,t_range)

ind = find(~isnan(T));
T = T(ind);
DATA = DATA(ind,:);

[xx, yy] = meshgrid(T,t_range);

k = (xx+yy-1)*length(T)+repmat(1:length(T),length(t_range),1);

x = DATA(k);