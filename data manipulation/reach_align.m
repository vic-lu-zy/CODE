for ii = 1:413
    Tx(ii) = find(x(ii,3000:8000)<-11,1)+3000;
    Ty(ii) = find(y(ii,3000:8000)<-15,1)+3000;
end