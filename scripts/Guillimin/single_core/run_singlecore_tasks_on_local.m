%% run_singlecore_tasks_on_local

% ccc

options.path = 'D:/NPL_DATA/M20100412_245/';
options.path_out = 'C:/Users/vic/Google Drive/Thesis/figures/20100412/';
options.task = 'Saccade';

options.time_interval = -500:500;
% 
% options.time_interval   = -500:2500;
% options.time_window     = 64;
% options.time_step       = 5;
% options.NFFT            = 512;

% extract_spectrogram_pmtm(options);
% extract_spectrogram_pmtm_by_trial(options);

print_figure_eye_traces_vs_lfp_vs_spect(options);