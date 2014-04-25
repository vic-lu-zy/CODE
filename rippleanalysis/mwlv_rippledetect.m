function mwlv_rippledetect(ripples, events, varargin)
%
%
% ripples = original ripple signal
% events = output of mwlf_rippledetect
%
% optional arguments:
%
% plottype = 1 =-=> matrix of subplots
% plottype = 2 =-=> one figure, scroll through
% plottype = 3 =-=> one figure, plot ripple data, with events in red
% nsubplots    =-=> restrict number of plots printed
% nrows        =-=> number of rows per figure
% nocols       =-=> number of cols per figure
% ids          =-=> only show certain events, index vector
% relamp       =-=> choose axis to show relative amplitude
%
%
%
%
% $id$
   
  K = length(events.startid);
  opt.plottype = 1;
  opt.nsubplots = 0;
  opt.nrows = 5;
  opt.ncols = 10;
  opt.ids = [];
  opt.relamp = 1;
  
  ripples = ripples(:)';
  
  J = 1;
  while J <= length(varargin)      
    switch(lower(varargin{J}))
     case 'nsubplots'
      if isnumeric(varargin{J+1})
        opt.nsubplots = varargin{J+1};
      end
     case 'nrows'
      if isnumeric(varargin{J+1})
        opt.nrows = varargin{J+1};
      end
     case 'ncols'
      if isnumeric(varargin{J+1})
        opt.ncols = varargin{J+1};
      end
     case 'plottype'
      if isnumeric(varargin{J+1})
        opt.plottype = varargin{J+1};
      end
     case 'ids'
      if isnumeric(varargin{J+1})
        opt.ids = varargin{J+1};
      end
     otherwise
    end
    J = J + 2;
  end
       
  
  if length(opt.ids) == 0
    opt.ids = 1:length(events.startid);
  end 
  
  %% PLOT ALL RIPPLES
  if opt.plottype == 1
    
    fignum = 100;
    nrows = opt.nrows;
    ncols = opt.ncols;
    naxis = nrows*ncols;
    count = 1;
    
    if (opt.nsubplots) > 0
      K = opt.nsubplots;
    else
      K = nrows*ncols;
    end
    K = min(K, length(events.startid(opt.ids)));
    
    if opt.relamp == 1
      maxrip = 0; maxds = 0; maxl = 0;
      for m = 1:length(opt.ids)
        k = opt.ids(m);        
        maxrip = max([abs(ripples(events.startid(k):events.endid(k))), maxrip]);
        maxds  = max([abs(events.detectsignal(events.startid(k):events.endid(k))); maxds]);
      end
      maxl = max(events.endid - events.startid + 1);
    end
    times = (1:maxl).*(1/events.samplefreq);

    maxrip = max(ripples);     
    minrip = min(ripples);

    m = 1;
    while m <= K
      
      k = opt.ids(m);
      if mod(m,naxis) == 1
        fignum = 101;
        while ishandle(fignum) == 1
          fignum = fignum + 1;
        end
        figure(fignum);
        set(gcf, 'color', [1 1 1], 'PaperPosition', [0.25 0.5 8 10]);
        count = 1;
      else
        count = count + 1;
      end
      
      subplot(nrows, ncols, count);
                  
      ripdata = ripples(events.startid(k):events.endid(k));
      l = events.endid(k)-events.startid(k) + 1;
      
      %detectdata = events.detectsignal(events.startid(k):events.endid(k));
      
      plot(times(1:l), ripdata);
      %hold on;
      %plot(detectdata, 'k');
      
      if mod(m,naxis) ~= 1
        set(gca, 'ytick', [], 'xtick', [], 'xcolor', [1 1 1], 'ycolor', [1 1 1]);
      else
        xlabel('seconds');
        ylabel('mV');
      end
      axis([0 maxl/events.samplefreq minrip maxrip]); 
      
      m = m + 1;
    end
    
  elseif opt.plottype == 2
    
    maxds = max(events.detectsignal);
    minds = min(events.detectsignal);
    
    
    figure(100);    
    for m = 1:K
      k = opt.ids(m);
      
      subplot(2,1,1);
      ripdata = ripples(events.startid(k):events.endid(k));
      plot(ripdata);
      axis tight;
      
      subplot(2,1,2);
      detectdata = events.detectsignal(events.startid(k):events.endid(k));
      plot(detectdata);
      axis tight;
      
      title(sprintf('%d', k ));

      pause
      cla
      
    end
  elseif opt.plottype == 3
      
      
    %figure(100); clf;
    plot(ripples);
    hold on
    ripples2 = zeros(size(ripples)).*NaN;
      
    for m = 1:K
      k = opt.ids(m);
        ripples2(events.startid(k):events.endid(k)) = ...
            ripples(events.startid(k):events.endid(k));
    end
    plot(ripples2, 'r');
    
    
  end
  
