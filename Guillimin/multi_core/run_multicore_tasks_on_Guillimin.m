%% run_multicore_tasks_on_Guillimin

% batch(parcluster('Guillimin'),'run_multicore_tasks_on_Guillimin', 'matlabpool', 15);

cd ~

%%
% options.path = '~/gs/20100407/';
options.path = '~/gs/20100421/';

% options.task = 'Reach';
options.task = 'Saccade';
% options.task = 'Pursuit';

options.time_interval   = -500:500;
options.time_window     = 32;
options.time_step       = 5;
options.NFFT            = 512;

%%
% extract_spectrogram_pmtm_by_trial(options);
extract_spectrogram_pmtm(options);