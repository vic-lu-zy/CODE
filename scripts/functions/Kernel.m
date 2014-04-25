function K = Kernel(U,V,fun)

K = zeros(size(U,1),size(V,1));

for i = 1:size(U,1)
    for j = 1:size(V,1)
        K(i,j) = fun(U(i,:)',V(j,:)');
    end
end