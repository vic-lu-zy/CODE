%% run_multicore_tasks_on_local

% ccc

options.path = 'D:/NPL_DATA/M20100407_456/';
options.task = 'Pursuit';

options.time_interval   = -500:2500;
options.time_window     = 64;
options.time_step       = 5;
options.NFFT            = 512;

% extract_spectrogram_pmtm(options);
extract_spectrogram_pmtm_by_trial(options);