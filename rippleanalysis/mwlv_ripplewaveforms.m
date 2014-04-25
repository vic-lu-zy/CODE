function mwlv_ripplewaveforms(ripples, events)
%% function mwlv_ripplewaveforms(ripples, events)
%% TRIGGER ON MAXIMUM AMPLITUDE
%% GET AVERAGE FREQUENCY CURVE
%% GET AVERAGE FM CURVE
%% David P. Nguyen <dpnguyen@mit.edu>
%% $id$

figure;
set(gcf, 'color', [1 1 1], 'Position', [100 600 600 600]);

linecolors = [0 0 0];
linestyle = {'-'};
ylabelfontsize = 10;
xlabelfontsize = 10;
xtickfontsize = 8;
ytickfontsize = 8;
boxlinewidth = 2;
datalinewidth = 1;
panellabelfontsize = 12;
plotlabelfontsize = 6;
titlefontsize = 8;


samplefreq = events.samplefreq;
win50ms  = ceil(0.05*samplefreq);
idwindow = -win50ms:win50ms;
timewindow = idwindow./samplefreq;

k = 1;
j = 1;

stats(k,j).freqmodv = zeros(length(idwindow), length(events.startid));
stats(k,j).instfreqv = zeros(size(stats(k,j).freqmodv));
stats(k,j).ampenvv = zeros(size(stats(k,j).freqmodv));
stats(k,j).ripplev = zeros(size(stats(k,j).freqmodv));
stats(k,j).N = length(events.startid);

for n = 1:length(events.startid)
  
  % GET ID OF MAX INST FREQ
  [maxamp, idmaxamp] = ...
      max(events.hilbertenv(events.startid(n):events.endid(n)));
  
  idmaxamp = idmaxamp + events.startid(n) - 1;
  idmaxampwin = idmaxamp-win50ms:idmaxamp+win50ms;
  
  %ripple trace
  ripple = ripples(idmaxampwin); 
  % ampenv
  ampenv = events.hilbertenv(idmaxampwin);
  % instfreq
  instfreq = events.instfreq(idmaxampwin);
  % freqmod
  freqmod = events.freqmod(idmaxampwin);
  
  stats(k,j).ripplev(:,n) = ripple(:);
  stats(k,j).ampenvv(:,n) = ampenv(:);
  stats(k,j).instfreqv(:,n) = instfreq(:);
  stats(k,j).freqmodv(:,n) = freqmod(:);
  
end
    

%% CALCULATE CUMULATIVE MEAN AND STARDARD DEVIATION
cumenv = zeros(length(idwindow),1);
stdenv = zeros(length(idwindow),1);
cuminstfreq = zeros(length(idwindow),1);
stdinstfreq = zeros(length(idwindow),1);
cumfreqmod = zeros(length(idwindow),1);
stdfreqmod = zeros(length(idwindow),1);
NN = 0;
    
     
for kk = 1:size(stats, 1)
  for jj = 1:size(stats, 2)
    
    stats(kk,jj).aveamp = mean(stats(kk,jj).ampenvv,2);
    stats(kk,jj).std_amp = std(stats(kk,jj).ampenvv, [], 2);
    
    stats(kk,jj).aveinstfreq = mean(stats(kk,jj).instfreqv, 2);
    stats(kk,jj).std_instfreq = std(stats(kk,jj).instfreqv, [], 2);

    stats(kk,jj).avefm = mean(stats(kk,jj).freqmodv,2);
    stats(kk,jj).std_fm = std(stats(kk,jj).freqmodv, [], 2);
    
    cumenv = cumenv + (stats(kk,jj).N).*(stats(kk,jj).aveamp);
    stdenv = stdenv + (stats(kk,jj).N).*(stats(kk,jj).std_amp.^2);
    
    cuminstfreq = cuminstfreq + (stats(kk,jj).N).*(stats(kk,jj).aveinstfreq);
    stdinstfreq = stdinstfreq + (stats(kk,jj).N).*(stats(kk,jj).std_instfreq.^2);
    
    cumfreqmod = cumfreqmod + (stats(kk,jj).N).*(stats(kk,jj).avefm);
    stdfreqmod = stdfreqmod + (stats(kk,jj).N).*(stats(kk,jj).std_fm.^2);
    
    NN = NN + stats(kk,jj).N;
  
    
    %% MAKE PLOTS
    nrows = 3; ncols = 1;
    sqrtN = sqrt(stats(kk,jj).N);
    sqrtN = 1;

    plotnum = 1;         
    subplot(nrows,ncols, plotnum);    
    plot(timewindow, stats(kk,jj).aveamp, linestyle{kk}, ...
         'linewidth', datalinewidth, 'color', linecolors(kk,:));
    hold on;

    plotnum = 2;
    subplot(nrows,ncols, plotnum);    
    plot(timewindow, stats(kk,jj).aveinstfreq, linestyle{kk}, ...
         'linewidth', datalinewidth, 'color', linecolors(kk,:));
    hold on;
    
    plotnum = 3;
    subplot(nrows,ncols, plotnum);    
    plot(timewindow, stats(kk,jj).avefm, linestyle{kk}, ...
         'linewidth', datalinewidth, 'color', linecolors(kk,:));
    hold on;
    
    
  end
end
    

cumenv = cumenv./NN;
cuminstfreq = cuminstfreq./NN;
cumfreqmod = cumfreqmod./NN;
stdenv = (stdenv./NN).^0.5;
stdinstfreq = (stdinstfreq./NN).^0.5;
stdfreqmod = (stdfreqmod./NN).^0.5;


plotnum = 1;         
subplot(nrows,ncols, plotnum);    
plot(timewindow, cumenv + stdenv, '-.', 'color', [0 0 0], ...
     'linewidth', datalinewidth);
plot(timewindow, cumenv - stdenv, '-.', 'color', [0 0 0], ...
     'linewidth', datalinewidth);
axis tight;
a = axis; axis(a + [0 0 -0.1*(a(4)-a(3)) 0.1*(a(4)-a(3))]);
xlim([-0.05 0.05]);
set(gca, 'linewidth', boxlinewidth, 'fontsize', 12, 'fontweight', 'bold');
ylabel('Amplitude (mV)', 'FontSize', ylabelfontsize);
%set(gca, 'yticklabel', {'0.5', '1', '1.5', '2'});

plotnum = 2;
subplot(nrows,ncols, plotnum);    
plot(timewindow, cuminstfreq + stdinstfreq, '-.', 'color', [0 0 0], ...
     'linewidth', datalinewidth);
plot(timewindow, cuminstfreq - stdinstfreq, '-.', 'color', [0 0 0], ...
     'linewidth', datalinewidth);
axis tight;
a = axis; axis(a + [0 0 -0.1*(a(4)-a(3)) 0.1*(a(4)-a(3))]);
xlim([-0.05 0.05]);
set(gca, 'linewidth', boxlinewidth, 'fontsize', 12, 'fontweight', 'bold');
ylabel('Inst. Freq. (Hz)', 'FontSize', ylabelfontsize);

plotnum = 3;
subplot(nrows,ncols, plotnum);    
plot(timewindow, cumfreqmod + stdfreqmod, '-.', 'color', [0 0 0], ...
     'linewidth', datalinewidth);
plot(timewindow, cumfreqmod - stdfreqmod, '-.', 'color', [0 0 0], ...
     'linewidth', datalinewidth);
axis tight;
a = axis; axis(a + [0 0 -0.1*(a(4)-a(3)) 0.1*(a(4)-a(3))]);
xlim([-0.05 0.05]);
set(gca, 'linewidth', boxlinewidth, 'fontsize', 12, 'fontweight', 'bold');
ylabel('Freq. Mod. (Hz/sec)', 'FontSize', ylabelfontsize);
xlabel('Time (sec)', 'FontSize', xlabelfontsize);

