%% run_multicore_tasks_on_Guillimin

cd ~

% fileID = fopen('output.txt','w');
% fwrite(fileID,['Start time : ' datestr(now) '\n'])

options.path = '~/gs/20100407/';
options.task = 'Pursuit';

options.time_interval   = -500:2500;
options.time_window     = 128;
options.time_step       = 5;
options.NFFT            = 512;

extract_spectrogram_pmtm_by_trial(options);

% fwrite(fileID,['End Time : ' datestr(now) '\n']);

% fclose(fileID);