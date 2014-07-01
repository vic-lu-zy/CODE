function A = extract_time_range(X,T,t_range)

[xx, yy] = meshgrid(T,t_range);

k = (xx+yy-1)*length(T)+repmat(1:length(T),length(t_range),1);

A = X(k);
