% options.path = 'D:/NPL_DATA/M20140412_245/';
options.path = '~/gs/20100407/';
options.task = 'Saccade';

options.time_interval   = -200:500;
options.time_window     = 64;
options.time_step       = 5;
options.NFFT            = 512;

myCluster = parcluster('Guillimin');
j = batch(myCluster,'extract_spectrogram_pmtm(options)', ...
    'matlabpool', 15, 'CurrentDirectory', '.');
