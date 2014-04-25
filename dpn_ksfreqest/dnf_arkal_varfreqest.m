function [freqvar] = dnf_arkal_varfreqest(A, AVar, Fs, N)
%
% [freqvar] = dnf_arkal_varfreqest(A, AVar, Fs, CI, N)
%
% A is the AR coefficients of the form:
%
%   y0 = a1*y1 + a2*y2 + ... + an*yn + error
%   A = [a1 a2 ... an], n-by-M
%
% AVar = Covariance Matrix of Vector A n-by-n-M
%  use the function dnf_arkal_smoothedvar.m to obtain this maxtrix   
%
% where M is the number of iterations in Kalman Filter
%
% Fs = sampling freq (by default it is 1);
%
% N = number of monte carlo samples (by default 1000);
%
% OUTPUT:
%  freqvar = The variance of the freq-estimate
%
% $id$

%% SAMPLE THE A's
if ~exist('N', 'var')
  N = 1000;
end
if ~exist('Fs', 'var')
  Fs = 1; 
end

A = squeeze(A);
AVar = squeeze(AVar);

SizeA = size(A);
L = SizeA(1);
M = SizeA(2);

freqvar = zeros(M,1);
for m = 1:M
  
  Am = A(:,m);
  SAm = AVar(:,:,m);
  L = numel(Am);
  
  % Draw random variables
  Atemp = repmat(Am, [1 N]) + chol(SAm)*randn(L,N);
  
  tmproots = zeros(L,N);
  for n = 1:N
    tmp = roots(fliplr([1, -Atemp(:,n)']));
    if numel(tmp) ~= L
      tmproots(:,n) = [tmp; zeros(L-length(tmp),1)];
    else
      tmproots(:,n) = tmp;
    end
  end
  
  F = angle(tmproots);
  F = sort(F, 1);
  F = F(1,:);
  
  % remove non-oscillatory roots
  F = F(F ~= 0);
  F = F(F ~= pi);
  
  F = F.*(1/pi).*(Fs/2);

  freqvar(m) = var(F);

end

