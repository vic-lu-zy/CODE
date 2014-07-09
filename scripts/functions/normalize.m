function y = normalize(x,n)

switch n
    case 1
        y = x ./ repmat(max(abs(x)),size(x,1),1);
    case 2
        y = x ./ repmat(max(abs(x),[],2),1,size(x,2));
end