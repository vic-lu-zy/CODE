function rate = SVMparamSearch(X,Y,sigma)

c = cvpartition(Y,'k',10);

fun = @(xT,yT,xt,yt)(sum(yt==svm(xt,xT,yT,sigma)));

rate = sum(crossval(fun,X,Y,'partition',c))/sum(c.TestSize);

end

function yt = svm(xt,xT,yT,sigma)

u = unique(yT);

if length(u)==2
    svmStruct = svmtrain(xT,yT,'kernel_function','rbf','rbf_sigma',sigma);
    yt = svmclassify(svmStruct,xt);
else
    pred = zeros(size(xt,1),length(u));
    for ii = 1:length(u)
        svmStruct = svmtrain(xT,yT==u(ii),...
            'kernel_function','rbf','rbf_sigma',sigma);
        pred(:,ii) = svmclassify(svmStruct,xt);
    end
    [~,yt] = max(pred,[],2);
end

end

% function rate = SVMparamSearch(X,Y,degree)
% 
% c = cvpartition(Y,'k',10);
% 
% fun = @(xT,yT,xt,yt)(sum(yt==svm(xt,xT,yT,degree)));
% 
% rate = sum(crossval(fun,X,Y,'partition',c))/sum(c.TestSize);
% 
% end
% 
% function yt = svm(xt,xT,yT,degree)
% 
% u = unique(yT);
% 
% if length(u)==2
%     svmStruct = svmtrain(xT,yT,'kernel_function','polynomial','polyorder',degree);
%     yt = svmclassify(svmStruct,xt);
% else
%     pred = zeros(size(xt,1),length(u));
%     for ii = 1:length(u)
%         svmStruct = svmtrain(xT,yT==u(ii),...
%             'kernel_function','polynomial','polyorder',degree);
%         pred(:,ii) = svmclassify(svmStruct,xt);
%     end
%     [~,yt] = max(pred,[],2);
% end
% 
% end