%% run_multicore_tasks_on_Guillimin

cd ~

fileID = fopen('output.txt','w');
fwrite(fileID,['Start time : ' datestr(now) '\n'])

options.path = '~/gs/20100407/';
options.task = 'Saccade';

options.time_interval   = -200:500;
options.time_window     = 64;
options.time_step       = 5;
options.NFFT            = 512;

extract_spectrogram_pmtm(options);

fwrite(fileID,['End Time : ' datestr(now) '\n']);

fclose(f);