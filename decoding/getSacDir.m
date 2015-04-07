function pred = getSacDir(X,netX,Y,netY)

pred = zeros(length(X),1);
[~,x] = max(netX(X));
[~,y] = max(netY(Y));

pred(x==1 & y==3) = 1;
pred(x==2 & y==3) = 3;
pred(x==3 & y==1) = 2;
pred(x==3 & y==2) = 4;