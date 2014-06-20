function result = ssd(u,v)

result = zeros(size(u,1),size(v,1));

for i = 1:size(u,1)
    for j = 1:size(v,1)
        temp = (u(i,:)-v(j,:));
        result(i,j) = temp*temp';
    end
end