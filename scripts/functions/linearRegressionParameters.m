
function [W] = linearRegressionParameters(X_in, y_in)


%X_in is N x d
%y_in is N x i
%W is d x i


W = pinv(X_in)*y_in;


end

