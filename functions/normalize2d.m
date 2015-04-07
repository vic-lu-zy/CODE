function y = normalize2d(x,n)

k = ones(1,ndims(x));
k(n) = size(x,n);

y = x ./ repmat(max(abs(x),[],n),k);
