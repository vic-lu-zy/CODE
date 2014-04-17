function y = normalize(x)

% x = x-repmat(min(x,[],2),1,size(x,2));
% 
% x = 2 * x./repmat(max(x,[],2),1,size(x,2));
% 
% y = x-1;

y = x ./ repmat(max(abs(x),[],2),1,size(x,2));