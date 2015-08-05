rate = zeros(3,length(num));
dir = {[1 3], 1:3, 1:4};
for ii = 1:3
    [X,Y,trials] = getXY(Spect,cl,dir{ii},1);
    [~,scores] = princomp(X(:,ind),'numcomponents',100);
    for jj = 1:length(num)
        rate(ii,jj) = LogisticRegression(scores(:,1:num(jj)),Y,100);
        semilogx(num,rate)
        drawnow
    end
end
rate
%%

rate = zeros(3,length(num));
% dir = {[1 3], 1:3, 1:4};
for ii = 1:3
    %     [X,Y,trials] = getXY(Spect,cl,dir{ii},1);
    for jj = 1:length(num)
        rate(ii,jj) = ANN(scores(:,1:num(jj)),Y,1);
        semilogx(num,rate)
        drawnow
    end
end
%%
rate = nan(3,length(num));
dir = {[1 3], 1:3, 1:4};
for ii = 1:3
    [X,Y,trials] = getXY(Spect,cl,dir{ii},1);
    [~,scores] = princomp(X(:,ind),'numcomponents',100);
    
    for jj = 1:length(num)
        rate(ii,jj) = pn_classify(scores(:,1:num(jj)),Y);
        semilogx(num,rate)
        drawnow
    end
end