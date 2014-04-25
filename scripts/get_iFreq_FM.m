function get_iFreq_FM(trial,f1,f2)
%% 1.  Determine the FreqBand of interest
%       Determine the frequency band that you're interested in analyzing.  
%       For example, 6 to 12 Hz for theta activity.

load LFP_Timing.mat
load(sprintf('lfp_trial_%03d',trial));

timing = 2500:4000;

timestamp = t(timing);
lfp = mean(LFP(33:end,timing));

% f1 = 20; f2 = 40; 
    
fc = 2*(f1+f2);

fs = 1000;

%% 2.  Resample the LFP data.  
%       Determine the new sampling rate by adding the 
%       two numbers that define the frequency boundary 
%       and then multiplying by two.  
%       For theta, (6+12)*2 = 36 Hz.  
%       Although 36 Hz is optimal, it may be OK to downsample 
%       the data to 40 Hz.

lfp2 = resample(lfp, 1, floor(fs/fc));  
timestamp2 = linspace(timestamp(1), timestamp(end), numel(lfp2));

%% 3.    Bandpass filter in the desired band.

lfp3 = filtfilt(fir1(floor(length(lfp2)/4), [f1 f2]/fc, 'bandpass'), 1, lfp2);

%% 4.    Apply the Kalman smoother 
%   to estimate the time-varying coefficients of the AR model.

[An, En] = dnf_arkal(lfp3, fc, 'sigma2v', 0.1, 'sigma2w', 0.1);
% lfp3 is you data (inside the algorithm, lfp3 is normalized)
% 40 is the sampling rate
% sigma2v is the expected noise variance, it has a range of [0 to 0.1]
% sigma2w is the expected parameter variance, it has a range of [0 to 0.1]

%% 5. 
%   Convert the AR coefficients into instantaneous 
%   frequency and FM estimates.

poleinfo = dnf_arkal_coef2poleinfo(An);
iFreq = (fc).*abs(poleinfo.polephase(1,:))./(2*pi);
FM = [0; diff(iFreq(:)).*fc];

%% 6. Examine the results.

figure(1)

clf;

s = subplot(3,1,1);
plot(timestamp2, lfp2, 'k');
drawTimeline_mv(s,trial,[min(lfp2) max(lfp2)]);

axis tight

s = subplot(3,1,2);
plot(timestamp2, iFreq, 'k');
drawTimeline_mv(s,trial,[min(iFreq) max(iFreq)]);

axis tight

s = subplot(3,1,3);
FM(abs(FM)>1000) = nan;
plot(timestamp2, FM, 'k');

drawTimeline_mv(s,trial,[min(FM) max(FM)]);

axis tight