function rate = lin_classify(X,cl)


numOfInst = size(X,1);

rate = sum(arrayfun(@(i)leaveOneOut(X,cl,i),1:numOfInst))/numOfInst;


end

function result = leaveOneOut(X,cl,i)
    train = X([1:i-1 i+1:end],:);
    test  = X(i,:);
    group = cl([1:i-1 i+1:end]);
    result = (cl(i)==linearClassification(train,group,test));
end