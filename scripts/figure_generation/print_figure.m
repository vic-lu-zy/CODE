%% print_figure

% ccc

% print figures based on data located in cfg.path_data to the directory
% specified by cfg.path_out. Other parameters are as specified per the
% functions

f = figure(1);

dir = 'D:/NPL_DATA/M20100412_245/';

cfg.path_data{1} = [dir 'LFP_Spect_Saccade_064_005_512_pmtm'];
cfg.path_data{2} = [dir 'cl65'];
cfg.path_out = 'C:/Users/vic/Google Drive/Thesis/figures/20100412/Saccade/By_Channel_032ms/';

% cfg.freq = [50,1,10,30]; % 512 ms
% cfg.freq = [140 30 60 120]; % 32 ms
% cfg.freq = [140 30 60 120]; % 256 ms

if ~isdir(cfg.path_out)
    mkdir(cfg.path_out)
end

by_channel(f,cfg);

close(f)