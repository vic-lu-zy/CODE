%% run_multicore_tasks_on_local

% ccc

options.path = 'D:/NPL_DATA/M20100407_456/';
options.task = 'Saccade';

options.time_interval   = -200:500;
options.time_window     = 64;
options.time_step       = 5;
options.NFFT            = 512;

extract_spectrogram_pmtm(options);
