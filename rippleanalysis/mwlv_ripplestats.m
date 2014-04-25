function mwlv_ripplestats(rs, varargin)
% MWLV_RIPPLESTATS(ripstats, varargin)
%
% OPTIONS:
%
% 'plottype' : [array of numbers specify plot types]
% 'dataids' : [ids of points to draw histograms with]
%
% PLOT TYPES:
% HISTOGRAMS
% 1) LENGTH
% 2) NSUBRIPS
% 3) MAXAMP
% 4) MAXFREQ
% 5) MINFREQ
% 6) MAXFREQMOD
% 7) MINFREQMOD
% 8) MAXFREQ - MINFREQ
% 9) MAXFREQMOD - MINFREQMOD
% 10) MEANFREQMOD
% 11) TMAXFREQ - TMAXAMP
% 12) TMINFREQ - TMAXAMP
% 13) TMAXFREQMOD - TMAXAMP
% 14) TMINFREQMOD - TMAXAMP
% 15) INTER-RIPPLE INTERVAL
% 16) LOG INTER-RIPPLE INTERVAL
%
% SCATTER PLOTS
% 20) NSUBRIPS VS. RIPPLE LENGTH
% 21) MAXAMP VS. MAX FREQ
% 22) MAXAMP VS. MAX FREQ MOD
% 23) MAXAMP VS. MIN FREQ MOD
% 24) MAXAMP VS. (MAX FREQMOD - MIN FREQMOD)
% 25) MAXAMP VS. (MAX FREQ - MIN FREQ)
% 26)
%
%  default 3, 16, 13, 14, 8, 9
% $Id: mwlv_ripplestats.m,v 1.2 2007/12/17 15:08:38 dpnguyen Exp $

  J = 1;
  while J <= length(varargin)      
    switch(lower(varargin{J}))
     case 'plottype'
      if isnumeric(varargin{J+1})
        plottype = varargin{J+1};
      end
     case 'dataids'
      if isnumeric(varargin{J+1})
        dataids = varargin{J+1};
      end      
     otherwise
    end
    J = J + 2;
  end
  
  if ~exist('plottype')
    plottype = [3, 16, 13, 14, 8, 9];
  end
  if length(plottype) == 0
    plottype = [3, 16, 13, 14, 8, 9];
  end    
  
  if exist('dataids')
    fn = fieldnames(rs);
    L = zeros(length(fn),1);
    L0 = length(getfield(rs, 'eventids'));
    for k = 1:length(fn)
      L(k) = length(getfield(rs, fn{k}));
    end
    LL = find(L == L0)
    for k = 1:length(LL)
      tmp = getfield(rs,fn{LL(k)});
      rs = setfield(rs, fn{LL(k)}, tmp(dataids));
    end
  end
  
  Nplots = length(plottype);
  tmp = floor(sqrt(Nplots));
  nrows = tmp;
  ncols = ceil(Nplots/tmp);
  scatterp{25} = [];
  histograms{16} = [];
  
  for K = 1:Nplots
    plotid = plottype(K);
    switch(plotid)
     case 1
      histograms{1} = rs.length;
     case 2
      histograms{2} = rs.nsubrips;
     case 3
      histograms{3} = rs.maxamp;
     case 4      
      histograms{4} = rs.maxfreq;
     case 5
      histograms{5} = rs.minfreq;
     case 6
      histograms{6} = rs.maxfreqmod;
     case 7
      histograms{7} = rs.minfreqmod;
     case 8
      histograms{8} = rs.maxfreq-rs.minfreq;
     case 9
      histograms{9} = rs.maxfreqmod-rs.minfreqmod;
     case 10
      histograms{10} = rs.meanfreqmod;
     case 11
      histograms{11} = (rs.idmaxfreq - rs.idmaxamp)./rs.samplefreq;
     case 12
      histograms{12} = (rs.idminfreq - rs.idmaxamp)./rs.samplefreq;
     case 13
      histograms{13} = (rs.idmaxfreqmod - rs.idmaxamp)./rs.samplefreq;
     case 14
      histograms{14} = (rs.idminfreqmod - rs.idmaxamp)./rs.samplefreq;
     case 15
      histograms{15} = rs.iei;
     case 16
      histograms{16} = log10(rs.iei);
     case 20
      scatterp{20,1} = rs.nsubrips;
      scatterp{20,2} = rs.length;
     case 21
      scatterp{21,1} = rs.maxamp;
      scatterp{21,2} = rs.maxfreq;
     case 22
      scatterp{22,1} = rs.maxamp;
      scatterp{22,2} = rs.maxfreqmod;
     case 23
      scatterp{23,1} = rs.maxamp;
      scatterp{23,2} = rs.minfreqmod;
     case 24
      scatterp{24,1} = rs.maxamp;
      scatterp{24,2} = rs.maxfreqmod - rs.minfreqmod;
     case 25
      scatterp{25,1} = rs.maxamp;
      scatterp{25,2} = rs.maxfreq - rs.minfreq;
     otherwise
    end
  end
  
  %% SET LIMTS FOR EASIER COMPARISONS
  xlimits{2} = [0 10];
  xlimits{4} = [100 200];
  xlimits{5} = [100 200];
  xlimits{9} = [0 2000];
  xlimits{8} = [0 100];
  xlimits{6} = [0 2000];
  xlimits{7} = [0 2000];
  xlimits{10} = [0 2000];
  xlimits{11} = [-0.05 0.05];
  xlimits{12} = [-0.05 0.05];
  xlimits{13} = [-0.05 0.05];
  xlimits{14} = [-0.05 0.05];
  xlimits{15} = [0 30];
  xlimits{16} = [-2 2];
  xlimits{length(scatterp)} = [];
  
 xlabels = {'Ripple Length (sec)', ... %1
             '# Sub-Ripples', ...
             'Max Amplitude', ...
             'Max Freq (Hz)', ...
             'Min Freq (Hz)', ...
             'Max Freq Mod (Hz)', ... %6
             'Min Freq Mod (Hz)', ...
             '\Delta Freq (Hz)', ...
             '\Delta Freq Mod (Hz)', ...
             'Mean Freq Mod', ...
             'T_{maxfreq} - T_{maxamp} (sec)', ... %11
             'T_{minfreq} - T_{maxamp} (sec)', ...
             'T_{maxfreqmod} - T_{maxamp} (sec)', ...
             'T_{minfreqmod} - T_{maxamp} (sec)', ...
             'Inter Ripple Interval (sec)', ...
             'Log_{10} Inter Ripple Interval (sec)', ... %16
             '', ...
             '', ...
             '', ...
             '# Sub-Ripples', ...
             'Max Amplitude', ... %21
             'Max Amplitude', ...
             'Max Amplitude', ...
             'Max Amplitude', ...
             'Max Amplitude'};
             
  ylabels{20} = 'Ripple Length (sec)';
  ylabels{21} = 'Max Freq (Hz)';
  ylabels{22} = 'Max Freq Mod (Hz)';
  ylabels{23} = 'Min Freq Mod (Hz)';
  ylabels{24} = '\Delta Freq Mod (Hz)';
  ylabels{25} = '\Delta Freq (Hz)';
      
  for K = 1:16
    histid{K} = K;
  end
  for K = 20:25
    scatterid{K} = K;
  end
  
  figure;
  Nplots
  for K = 1:Nplots
    plotid = plottype(K);
    subplot(nrows,ncols,K);
    switch plotid
     case histid
      hist(histograms{plotid},50);
      xlabel(xlabels{plotid});      
     case scatterid
      plot(scatterp{plotid,1}, scatterp{plotid,2}, '.');
      xlabel(xlabels{plotid});
      ylabel(ylabels{plotid});
     otherwise
      'unknown plot'
    end

    if length(xlimits{plotid}) > 0
      xlim(xlimits{plotid});
    end
  end
