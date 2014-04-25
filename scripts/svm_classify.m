function [result,rate] = svm_classify(X,cl,kf)

numOfInst = size(X,1);

result = arrayfun(@(i)leaveOneOut(i),1:numOfInst);
rate = nansum(result(:)==cl(:))/numOfInst;

    function result = leaveOneOut(i)
        train = X([1:i-1 i+1:end],:);
        test  = X(i,:);
        group = cl([1:i-1 i+1:end]);
        result = multisvm(train,group,test,kf);
    end

end