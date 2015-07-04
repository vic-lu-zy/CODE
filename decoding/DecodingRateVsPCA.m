%% Compare decoding performance vs PCA numbers

[X,Y] = getXY(LogBin(1,:,18:32,:),cl,[1,3],1);
rate = 1:50;

for ii = 1:50
%     [~,thisX] = pca(X,'algorithm','eig','NumComponents',ii);
    dims = rankfeatures(X',Y,'NumberOfIndices',ii);
    thisX = X(:,dims);
%     K = X*X';
%     [~,~,V] = svd(K);
%     thisX = K*V(:,1:ii);
    
    Mdl = fitcecoc(thisX,Y,'Learners',t);
    CVMdl = crossval(Mdl,'leaveout','on');
    rate(ii) = 1 - kfoldLoss(CVMdl);
end
%%
clf
plot(repmat(r,50,1))
hold on
stairs(rate)