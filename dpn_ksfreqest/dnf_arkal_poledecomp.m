function Output = dnf_arkal_poledecomp(An, varargin)
% Output = dnf_arkal_poledecomp(An, varargin)
%
% For each timestep, and each pole, compute the  
%  roots, angle/phase/freq, magnitude, spectrogram contribution
% Also compute the spectrogram for the whole model
% 
% Input:
%   An is output of dnf_arkal.  A matrix of AR coefficients
%   in column order, where each column is a time instance.
%   The size of the column is P (the order of the AR model) 
%   
% Options, defaults in brackets:
%  'fs' = sampling freq [1]
%  'index' = vector of discrete time indices to do decomp
%  'psdres' = number of points to eval on freq axis
%  'dospecgram' = set to nonzero if want specgram to be computed
%  'timestamp' = default is to use indices
%
% Output:
%  roots, poleangle, polemag, w, timestamp, speccomp, specgram, fs
%
%
%  Author: David P. Nguyen <dpnguyen@mit.edu>, 
%  August 2007
%  $Id$
      
  An = squeeze(An);
  sa = size(An);
  P = sa(1);
  N = sa(2);

  opt.fs = 1;
  opt.index = 1:N;
  opt.psdres = 25;
  opt.dospecgram = 0;
  opt.timestamp = [];
  
  opt = parsevarargin(varargin, opt);  

  if length(opt.timestamp) == 0
    opt.timestamp = 1:N;
  end
  
  N = length(opt.index);
  N2 = sa(2);
  
  omega = linspace(0.00001, pi, opt.psdres);
  omega = omega(:);

  index = [0:P];
  index = index(:);
  
  % setup basis vectors
  vectej1 = exp(-j*omega);
  vectej2 = exp(j*omega);

  Pcomp = zeros(length(omega), N, P);

  % precalculate the roots
  Output.roots = zeros(P, N);
  Output.polephase = [];
  Output.polemag = [];
  
  %% if there are empty coefficeints do 
  %% initialization ??
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  nn = 1;
  while sum(An(:,nn)) == 0
    nn = nn + 1;
  end
  for nnn = nn:-1:1
    An(:,nnn) = An(:,nn);
  end
 
  An(~isfinite(An(:))) = 0;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  
  for n = 1:length(opt.index)
    % first get the vector containing the coefficients of the
    % characteristic polynomial. then calculate roots.
    % ROOTS(C) computes the roots of the polynomial whose coefficients
    % are the elements of the vector C. If C has N+1 components,
    % the polynomial is C(1)*X^N + ... + C(N)*X + C(N+1).
    nn = opt.index(n);
    tmp = roots(fliplr([1, -An(:,nn)']));
    Output.roots(:,n) = [tmp; zeros(P-length(tmp),1)];
  end
  
  
  % CALCULATE ANGLE, THEN SORT EVERYTHING BY ANGLE
  Output.polephase = angle(Output.roots);
  % [Output.polephase, IX] = trackpolebyangle(double(Output.polephase));   
  [Output.polephase, IX] = sort(Output.polephase,1);
  
  % RE-ARRANGE ROOTS BASED ON ANGLE, AND COMPUTE POLES
  for nn = 1:N
    Output.roots(:,nn) = Output.roots(IX(:,nn),nn); 
  end
  Output.polemag = abs(Output.roots);
  
  
  wv = linspace(0, pi, opt.psdres);
  Output.w = wv;
  Output.timestamp = opt.timestamp;
  
  % put in other dimensions to make consistent with multivariate case
  if opt.dospecgram ~= 0
    Output.speccomp = zeros(length(wv), P, N);
    Output.specgram = zeros(length(wv), N);
    Sp1comp = zeros(length(wv), P);
  end

    
  for nn=1:N
        
    allpoles = Output.roots(:,nn);    
    
    % Matlab calculates the following residuals B(z) r(1) r(n) ---- =
    % ------------ +...  ------------ + k(1) + k(2)z^(-1) ...  A(z)
    % 1-p(1)z^(-1) 1-p(n)z^(-1)
    % Assumes A(z) = a0 + a1*z^-1 + ... + ak*z^-k
         
    % intermediate variable (Baselli, 1997) calls it gamma compute the
    % components of the spectrogram
    clear j;
            
    % CALCULATE THE SPECTROGRAM USING DECOMPOSITION Unlike in Baselli, who
    % uses 1/prod(z-p) for factors we use 1/prod(1-p*z^-1)
    
    % CALCULATE RESIDUALS AT EACH POLE
    for pk = 1:P
      z = allpoles(pk);
      %g(pk) = CovE(1,1,nn)./(z*prod(z - allpoles(setdiff(1:P,pk)))*prod(1/z - allpoles));
      g(pk) = 1./(z*prod(z - allpoles(setdiff(1:P,pk)))*prod(1/z - allpoles));
    end
    Output.polemag(:,nn) = g;
    
    
    % START DO SPECTROGRAM
    if opt.dospecgram ~= 0
      
      % DECOMPOSITION FORM 1    
      for wi = 1:length(wv)
        w = wv(wi);
        z = exp(j*w);
        
        for pk = 1:P        
          Sp1comp(wi, pk) = g(pk)*allpoles(pk)/(z - allpoles(pk)) + g(pk) ...
              + g(pk)*allpoles(pk)/(1/z - allpoles(pk));
        end
      end
      comproots = find(imag(allpoles) ~= 0);
      realroots = setdiff(1:P,comproots);
      
      Output.specgram(:,nn) = 2*real(sum(Sp1comp(:,comproots),2)) ...
          + real(sum(Sp1comp(:,realroots),2));
      
      Output.speccomp(:,:,nn) = real(Sp1comp);
      
      % CALCULATE THE SPECTROGRAM USING THE CLASSICAL DEFINITION
      if 1 == 0
        for wi = 1:length(wv)
          w = wv(wi);
          z = exp(j*w);
          
          cp = [1, -An(:,nn)'];
          ad1 = z.^(-(0:P));
          ad1 = ad1(:)';
          ad2 = z.^(0:P);
          ad2 = ad2(:)';
          cp = cp(:)';
        
          Sp3(wi) = CovE(1,1,nn)./(sum(ad1.*cp)*sum(ad2.*cp));
        end
      end
      
    end
    % END DO SPECTROGRAM
    
  end

  % reshape the output
  Output.speccomp = permute(Output.speccomp, [1 3 2]);

  Output.fs = opt.fs;
  Output.w = (Output.w).*(Output.fs./2./pi);
  
  
