function thresh = mwlf_ripplethreshold(signal, multiplier)
% thresh = mwlf_ripplethreshold(signal, multiplier)
%
% signal is any signal you want to detect ripples with
% multiplier, scales the std of the noise
%
% This function computes the noise std. and scales it to 
%  get the threshold
%
% David P. Nguyen <dpnguyen@mit.edu>
% $id$
  
  if ~exist('multiplier')
    multiplier = 1;
  end
  
  signal = double(signal);
  noisethresh1 = prctile(signal, 99);
  noisesignal = signal(find(signal < noisethresh1));
  noisestd = std(noisesignal);
  thresh = noisestd*multiplier;