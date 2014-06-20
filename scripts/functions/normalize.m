function y = normalize(x)
y = x ./ repmat(max(abs(x),[],2),1,size(x,2));