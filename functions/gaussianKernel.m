function K = gaussianKernel(X)

sigm = std(X(:));

m = size(X,1);

K = zeros(m);

for i = 1:m
    for j = 1:m
        temp = X(i,:)-X(j,:);
        K(i,j) = exp(-temp*temp'/(2*sigm^2));
    end
end