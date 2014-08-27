%% run_multicore_tasks_on_local

% batch('run_multicore_tasks_on_local','Pool',6);

options.path = 'D:/NPL_DATA/M20100412_245/';
options.task = 'Saccade';

options.time_interval   = -500:500;
options.time_window     = 256;
options.time_step       = 5;
options.NFFT            = 512;

extract_spectrogram_pmtm(options);
% extract_spectrogram_pmtm_by_trial(options);