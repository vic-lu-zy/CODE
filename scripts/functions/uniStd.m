function x = uniStd(x,dim)

assert(dim<=ndims(x))

sd = std(x,[],dim);

k = ones(1,ndims(x));
k(dim) = size(x,dim);

x = x./repmat(sd,k);