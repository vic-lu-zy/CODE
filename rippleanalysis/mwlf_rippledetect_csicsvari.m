function events = mwlf_rippledetect_csicsvari(ripples, samplefreq, varargin)
%
% events = mwlf_rippledetect_csicsvari(ripples, samplefreq, varargin)
%
% Option arguments:
% lowscale = multiplier for lower threshold (default 1)
% highscale = multiplier for high threshold (default 2)
% lowthresh = manually set the low threshold (scale not used)
% highthresh = manually set the high threshold (scale not used)
% concatoverlap = concatenate overlapping ripple events (default 0=no) 
% concatclose = if greater than 0, use this arg (seconds) to concat events
%             that are close together (default 0)  
% concatexactsame = for start:end pairs that are exactly the same, remove one
%                   like concatoverlap, except stronger criteria
%
% Required arguments:
% samplefreq = sampling rate
%
% $id$
  
events.startid = [];
events.endid = [];
events.idmarker = [];
events.hilbertenv = [];
events.ampinfo = [];
events.instfreq = [];
events.freqmod = [];
events.freqmodenv = [];
events.freqinfo = [];

events.detectsignal = [];
events.samplefreq = [];
events.npeaks = [];
events.nrips = [];
events.correctionid = [];
events.correctiontime = [];

events.mean = [];
events.std = [];
events.skewness = [];
events.kurtosis = [];
events.subtractmeans = [];

events.lowthresh = [];
events.highthresh = [];
events.skewthresh = -100;
events.lowscale = 1;
events.highscale = 1;
events.concatoverlap = 0;
events.concatclose = 0;
events.concatexactsame = 1;
events.reject = 0;
events.infodetect = 1;
events.enhancedetection = 1;

peaksper100ms = 1;

J = 1;
while J <= length(varargin)      
  switch(lower(varargin{J}))
   case 'concatexactsame'
    if isnumeric(varargin{J+1})
      events.concatexactsame = varargin{J+1};
    end
   case 'concatclose'
    if isnumeric(varargin{J+1})
      events.concatclose = varargin{J+1};
    end
   case 'concatoverlap'
    if isnumeric(varargin{J+1})
      events.concatoverlap = varargin{J+1};
    end
   case 'highscale'
    if isnumeric(varargin{J+1})
      if length(events.highscale) > 0
        events.highscale = varargin{J+1};
      end
    end
   case 'lowscale'
    if isnumeric(varargin{J+1})
      if length(events.lowscale) > 0
        events.lowscale = varargin{J+1};
      end
    end
   case 'highthresh'
    if isnumeric(varargin{J+1})
      events.highthresh = varargin{J+1};
      events.highscale = [];
    end
   case 'lowthresh'
    if isnumeric(varargin{J+1})
      events.lowthresh = varargin{J+1};
      events.lowscale = [];
    end
   otherwise
    fprintf(1, 'Do not know %s', varargin{J});
  end
  J = J + 2;
end


if ~exist('samplefreq')
  error('Need the appropriate sampling freq!!');
end

if ~exist('sampelfreq')
  samplefreq = 800; %Hz
end
dt = 1/samplefreq;

win1000ms = ceil(samplefreq);
win500ms = ceil(0.5*samplefreq);
win200ms = ceil(0.2*samplefreq);
win100ms = ceil(0.1*samplefreq);
win50ms  = ceil(0.05*samplefreq);
win25ms  = ceil(0.025*samplefreq);
win10ms  = ceil(0.01*samplefreq);
win5ms   = ceil(0.005*samplefreq);

events.correctionid = win50ms;
events.correctiontime = 50e-3;

ripples = ripples(:);

%% PROCESS AMPLITUDE INFORMATION
%% BY STANDARD DEVIATION SCALING
%% SET LOW AND HIGH THRESHOLDS
rhe = abs(hilbert(ripples));

%% FILTER THE ENVELOPE OF THE HILBERT TO GET A SMOOTHER ENVELOPE
smwin = hanning(win25ms)./sum(hanning(win25ms));
rhes = conv(rhe, smwin);
rhes = rhes(floor(win25ms/2):end-ceil(win25ms/2));
ampinfo = rhes;

%% ACCENTUATE PEAKS RELATIVE TO NOISE
% $$$ if events.enhancedetection == 1
% $$$   envsum = zeros(size(rhes));
% $$$   normfactor = zeros(size(rhes));
% $$$   for k = -win50ms:win50ms
% $$$     prepad = abs(min([k 0]));
% $$$     postpad = abs(max([k 0]));
% $$$     envsum = envsum + [zeros(prepad,1); rhes(postpad+1:end-prepad); zeros(postpad,1)];  
% $$$   end
% $$$   ampinfo = rhes.*envsum;
% $$$ else
% $$$   ampinfo = rhes;
% $$$ end
% $$$ ampinfo = ampinfo./max(abs(ampinfo));
  
ripdetect = ampinfo;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DETECT EVENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% IF THRESHOLD NOT SPECIFIED, CALCULATE FROM SIGNAL
if length(events.lowthresh) == 0
  %events.lowthresh = events.lowscale*std(ripdetect)
  if events.enhancedetection == 1
    events.lowthresh = 0;
  else
    events.lowthresh = mwlf_ripplethreshold(ripdetect, 3);
  end
end
if length(events.highthresh) == 0
  %events.highthresh = events.highscale*exp(prctile(log(ripdetect), 99.9))
  events.highthresh = mwlf_ripplethreshold(ripdetect, 7);
end

% FIND PRELIM CANDIDATES
ripple_ids = find(ripdetect > events.highthresh);
ripple_marker = zeros(size(ripples));
ripple_marker(ripple_ids) = 1;

% CONCATENATE EVENTS
% if points are within x ms of each other, call it one event
if(events.concatclose > 0)
  dr = diff(ripple_ids);
  concatwin = max(1,ceil(events.concatclose*samplefreq));
  idfill = find(dr <= concatwin);
  for k=1:length(idfill)
    j = idfill(k);
    ripple_marker(ripple_ids(j):ripple_ids(j+1)) = 1;
  end
  ripple_ids = find(ripple_marker == 1);
end


% FIND THE START AND END TIMES OF RIPPLES
dr = diff(ripple_marker);
stepup = find(dr == 1) + 1;
stepdown = find(dr == -1);
startrip = stepup(1:min(length(stepup), length(stepdown)));
endrip = stepdown(1:min(length(stepup), length(stepdown)));

%keyboard
% FIND THE START AND END TIMES OF RIPPLES
for k = 1:length(startrip)
  % do left
  lids = max(1,            startrip(k)-win500ms:startrip(k));
  rids = min(length(ripdetect), endrip(k):endrip(k)+win500ms);
  
  % update startrip(k), endrip(k), and ripple_marker
  tmp = max(find(ripdetect(lids) <= events.lowthresh));
  if length(tmp) == 0
    startrip(k) = max(1,startrip(k) - win500ms);
  else % CHECK THESE INDICES
    startrip(k) = max(1,startrip(k) - win500ms + tmp(end));
  end

  tmp = min(find(ripdetect(rids) <= events.lowthresh));
  if length(tmp) == 0
    endrip(k) = min(length(ripdetect), endrip(k) + win500ms);
  else % CHECK THESE INDICES
    endrip(k) = min(length(ripdetect), endrip(k) + tmp(1));
  end
  
  % update the ripple marker
end


%% COMBINE OVERLAPPING RIPPLES
if(events.concatoverlap > 0)
  stop = 0; k = 1;
  while(stop == 0)
    if (k < length(startrip))
      if endrip(k) >= startrip(k+1)
        startrip(k) = max(1, min(startrip(k:k+1)));
        endrip(k) = min(length(ripples), max(endrip(k:k+1)));
        endrip = endrip(setdiff(1:length(endrip),k+1));
        startrip = startrip(setdiff(1:length(startrip),k+1));
      else
        k = k + 1;
      end
    else
      stop = 1;
    end
  end
end

%% COMBINE RIPPLE EVENTS THAT ARE EXACTLY THE SAME
[startrip, sortid] = sort(startrip);
endrip = endrip(sortid);
if(events.concatexactsame > 0)
  stop = 0; k = 1;
  while(stop == 0)
    if (k < length(startrip))
      if (startrip(k) == startrip(k+1)) && (endrip(k) == endrip(k+1))
        endrip = endrip(setdiff(1:length(endrip),k+1));
        startrip = startrip(setdiff(1:length(startrip),k+1));
      else
        k = k + 1;
      end
    else
      stop = 1;
    end
  end
end


%% COMPUTE NUMBER OF RIPPLES IN A BURST
% can compute by looking at derivative
% can compute by doing threshold crossing
nrips = zeros(size(startrip));
for k = 1:length(startrip)  
  seg = ripdetect(startrip(k):endrip(k));
  seg = seg(:);
  sdseg = [0; sign(diff(seg))];
  
  sdseg = conv(sdseg, ones(1,win25ms)./win25ms);
  sdseg = sdseg(floor(win25ms/2):end-ceil(win25ms/2));
  sdseg = sign(sdseg);
  nrips(k) = length(find(diff(sdseg) < 0));
end

%% ADD CORRECTION TIMES TO RIPPLES
% $$$ if (events.enhancedetection > 0)
% $$$   startrip = startrip - events.correctionid;
% $$$   startrip = max(1, startrip);
% $$$   endrip = endrip + events.correctionid;
% $$$   endrip = min(endrip, length(ripdetect));
% $$$ end



%% END EVENTS
events.startid = startrip;
events.endid = endrip;
events.nrips = nrips;
events.detectsignal = single(ripdetect);

events.idmarker = single(zeros(length(ripples),1));
for k = 1:length(startrip)
  events.idmarker(startrip(k):endrip(k)) = 1;
end
events.idmarker = single(events.idmarker);
events.samplefreq = single(samplefreq);
events.hilbertenv = single(rhes);
events.ampinfo = single(ampinfo);


