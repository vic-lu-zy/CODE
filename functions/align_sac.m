function T = align_sac(x,ft)

t = 1:length(x);
x = double(x(:));

% x = x - mean(x(1:50));
% x = x./ mean(x(end-50:end));

f = fit(t',x,ft,'Lower',[40 45],'StartPoint',[50 55]);
T = round(f.x1);
