function x = normalize2d(x,n)

x = bsxfun(@minus,x,mean(x,n));
x = bsxfun(@rdivide,x,std(x,n));

% 
% k = ones(1,ndims(x));
% k(n) = size(x,n);
% 
% y = x ./ repmat(max(abs(x),[],n),k);
