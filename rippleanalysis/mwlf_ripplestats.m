function ripstat = mwlf_ripplestats(ripples, events, varargin)
%
% ripstat = mwlf_ripplestats(ripples, events, options)
%
% options:
%   plot: 0 or 1
%   ids: only plot certain ids, array of ids
%
%
% OBTAIN FEATURES AND STATISTICS FROM EACH SET OF RIPPLES
%
%
% $id$
   
opt.plot = 0;
opt.ids = [];

J = 1;
while J <= length(varargin)      
  switch(lower(varargin{J}))
   case 'plot'
    if isnumeric(varargin{J+1})
      opt.plot = varargin{J+1};
    end
   case 'ids'
    if isnumeric(varargin{J+1})
      opt.ids = varargin{J+1};
    end
   case 'instfreq'
    if isnumeric(varargin{J+1})
      win25ms  = ceil(0.025*events.samplefreq);
      
      events.instfreq = varargin{J+1};
      events.instfreq(1:100) = events.instfreq(101);
      
      difenv = real([0; diff(events.instfreq)]).*events.samplefreq;
      
      difenvtmp = conv(difenv, hanning(win25ms)./sum(hanning(win25ms)));
      difenvtmp = difenvtmp(floor(win25ms/2):end-ceil(win25ms/2));
      
      events.freqmod = difenvtmp;
    end
  end
  J = J + 2;
end

ids = opt.ids;
if (length(opt.ids) == 0)
  ids = 1:length(events.startid);
end


nE  = length(ids);
nR  = length(ripples);

ripstat.samplefreq = events.samplefreq;
ripstat.eventids = ids(:);
ripstat.idrip = zeros(nE,1);
ripstat.length = zeros(nE,1);
ripstat.nsubrips = ones(nE,1); % events.nrips(ids);
ripstat.maxamp = zeros(nE,1);
ripstat.idmaxamp = zeros(nE,1);
ripstat.maxfreq = zeros(nE,1);
ripstat.idmaxfreq = zeros(nE,1);
ripstat.minfreq = zeros(nE,1);
ripstat.idminfreq = zeros(nE,1);
ripstat.maxfreqmod = zeros(nE,1);
ripstat.idmaxfreqmod = zeros(nE,1);
ripstat.minfreqmod = zeros(nE,1);
ripstat.idminfreqmod = zeros(nE,1);
ripstat.meanfreqmod = zeros(nE,1);

ripstat.freqatmaxamp = zeros(nE,1);
ripstat.freqmodatmaxamp = zeros(nE,1);
ripstat.ampatmaxfreq = zeros(nE,1);
ripstat.deltafreqamppeaks = zeros(nE,1);

ripstat.meanunitriplength = zeros(nE,1);
ripstat.iei = zeros(nE-1,1);

samplefreq = events.samplefreq;
win200ms = ceil(0.2*samplefreq);
win100ms = ceil(0.1*samplefreq);
win60ms  = ceil(0.06*samplefreq);
win50ms  = ceil(0.05*samplefreq);
win30ms  = ceil(0.03*samplefreq);
win25ms  = ceil(0.025*samplefreq);
win15ms  = ceil(0.015*samplefreq);
win10ms  = ceil(0.01*samplefreq);

%% we want to do everything relative to the peak amplitude
%% search to the left 30ms and search to the right 30 ms
if length(events.startid) > 0

  ripstat.length = (events.endid(ids) - events.startid(ids))./samplefreq;
  maxampid = zeros(length(ids),1);
  
  for m = 1:length(ids)
    k = ids(m);
    [ripstat.maxamp(m), ripstat.idmaxamp(m)] = max(events.hilbertenv(events.startid(k):events.endid(k)));  
    maxampid(m) = events.startid(k) + ripstat.idmaxamp(m) - 1;
    
    if (length(events.instfreq) > 0)
      id1 = max(maxampid(m) - win10ms,1);
      id2 = min(maxampid(m) + win10ms,nR);
      [ripstat.maxfreq(m), ripstat.idmaxfreq(m)] = max(events.instfreq(id1:id2));  
      [ripstat.minfreq(m), ripstat.idminfreq(m)] = min(events.instfreq(id1:id2));
      [ripstat.maxfreqmod(m), ripstat.idmaxfreqmod(m)] = max(events.freqmod(id1:id2));  
      [ripstat.minfreqmod(m), ripstat.idminfreqmod(m)] = min(events.freqmod(id1:id2));  
      ripstat.meanfreqmod(m) = mean(events.freqmod(id1:id2));
      
      ripstat.idmaxfreq(m) = ripstat.idmaxfreq(m) + id1 - events.startid(k); 
      ripstat.idminfreq(m) = ripstat.idminfreq(m) + id1 - events.startid(k);
      ripstat.idmaxfreqmod(m) = ripstat.idmaxfreqmod(m) + id1 - events.startid(k);
      ripstat.idminfreqmod(m) = ripstat.idminfreqmod(m) + id1 - events.startid(k);      
    end
  end
  
  if (length(events.instfreq) > 0)
    tt = events.startid(ids) + ripstat.idmaxamp - 1;
    for idt = 1:length(tt)
      winmean = (tt(idt)-win10ms):(tt(idt)+win10ms);
      ripstat.freqatmaxamp(idt) = mean(events.instfreq(winmean));
      ripstat.freqmodatmaxamp(idt) = mean(events.freqmod(winmean));
    end
    ripstat.ampatmaxfreq = events.hilbertenv(events.startid(ids) + ripstat.idmaxfreq - 1);
    ripstat.deltaTfreqamppeaks = ripstat.idmaxfreq - ripstat.idmaxamp;
    
    ripstat.meanunitriplength = mean(ripstat.length./ripstat.nsubrips);
    ripstat.iei = diff(events.startid(ids))./samplefreq;
    ripstat.idrip = (events.startid(ids) + ripstat.idmaxfreq);
  end
  
  PLOT = 1;
else
  PLOT = 0;
end


%% PLOT THE RESULTS
if ((opt.plot == 1)&(PLOT == 1))
  
  figure
  set(gcf, 'paperposition', [0.25 0.5 8 10]);
  nrows = 4;
  ncols = 3;
  count = 0;
  
  %1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count = count + 1;
  subplot(nrows,ncols,count);
  hist(ripstat.maxamp, 50);
  title('Max Ripple Amplitude');
  xlabel('Amplitude');
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count = count + 1;
  subplot(nrows,ncols,count);
  hist(ripstat.maxfreq, 50);
  title('Max Inst Freq');
  xlabel('Frequency (Hz)');
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  
  %3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count = count + 1;
  subplot(nrows,ncols,count);
  hist(ripstat.freqatmaxamp, 50);
  title('Inst Freq at Peak Amplitude');
  xlabel('Frequency (Hz)');
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  
  %4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count = count + 1;
  subplot(nrows,ncols,count);
  hist(ripstat.ampatmaxfreq, 50);
  title('Amplitude at Max Inst Freq');
  xlabel('Amplitude');  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %5%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count = count + 1;
  subplot(nrows,ncols,count);
  tmp = log10(ripstat.iei);
  tmp = tmp(isfinite(tmp));
  hist(tmp, 50);
  title('Inter-Ripple Interval');
  xlabel('Time (log10(sec))');
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %6%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count = count + 1;  
  subplot(nrows,ncols,count);
  hist(ripstat.length, 50);
  [n,x] = hist(ripstat.length, 50);
  mostlikelyripplelength = x(find(n == max(n)))
  title('Ripple Length');
  xlabel('Seconds');
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
   
  %7%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count = count + 1;
  subplot(nrows,ncols,count);
  if (max(ripstat.nsubrips) > 1)
    hist(ripstat.nsubrips, max(ripstat.nsubrips)-1);
  end
  title('# Ripples per ripple burst');
  xlabel('N');  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %8%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count = count + 1;
  subplot(nrows,ncols,count);
  plot(ripstat.nsubrips, ripstat.length, '.');
  title('# Sub-Ripples vs. Ripple Length');
  xlabel('# Sub-Ripples');
  ylabel('Ripple Length (sec)');
  hold on;
  B = polyfit(ripstat.nsubrips, ripstat.length, 1);
  Ehist = linspace(0, max(ripstat.nsubrips), 3);
  plot(Ehist, B(1).*Ehist + B(2), 'r', 'linewidth', 2);  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %9%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count = count + 1;
  subplot(nrows,ncols,count);
  plot(ripstat.maxamp, ripstat.length, '.');
  title('Max Amplitude vs. Ripple Length');
  xlabel('Max Amplitude');
  ylabel('Ripple Length (sec)');
  hold on;
  B = polyfit(ripstat.maxamp, ripstat.length, 1);
  Ehist = linspace(0, max(ripstat.maxamp), 3);
  plot(Ehist, B(1).*Ehist + B(2), 'r', 'linewidth', 2);  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  
  %10%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  count = count + 1;
  subplot(nrows,ncols,count);
  hist(ripstat.deltafreqamppeaks./samplefreq, 50);
  title('t_{maxfreq} - t_{maxamp}');
  xlabel('Time (sec)');
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
  %11%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if(length(events.instfreq) > 0)
    count = count + 1;
    subplot(nrows,ncols,count);
    hist(ripstat.meanfreqmod);
    ravemodall = mean((diff(events.instfreq(ids))));
    hold on;
    plot([ravemodall ravemodall], ylim, 'r');
    title('Ave freq mod during ripple');
    xlabel('\Delta f / \Delta t');
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

  
  %12%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% $$$   count = count + 1;
% $$$   subplot(nrows,ncols,count);
% $$$   % do spiketriggered correlation
% $$$   % want a 200 ms window both ways
% $$$   xcorrip = xcorr(events.idmarker(ids));
% $$$   n = ceil(length(xcorrip)/2);
% $$$   j = 3;
% $$$   plot((-win200ms*j:win200ms*j)./samplefreq, xcorrip(-win200ms*j+n:n+win200ms*j));
% $$$   title('autocorr of ripple events');
% $$$   xlabel('Time (sec)');
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
  %12%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  count = count + 1;
  subplot(nrows,ncols,count);
  plot(ripstat.maxfreq, ripstat.maxamp, '.');
  title('max freq vs max amp');
  xlabel('freq (hz)');
  ylabel('amp');
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
end
