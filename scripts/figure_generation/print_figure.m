%% print_figure

% ccc

% print figures based on data located in cfg.path_data to the directory
% specified by cfg.path_out. Other parameters are as specified per the
% functions

f = figure(1);

cfg.window_size = 512;
cfg.path_data{1} = sprintf('/home/vic/NPLDATA/M20100412_245/spect_all_in_one/LFP_Spect_Saccade_%03i_005_512_pmtm',cfg.window_size);
cfg.path_data{2} = '/home/vic/NPLDATA/M20100412_245/cl65';
cfg.path_out = sprintf('/home/vic/Dropbox/thesis/figures/20100412/Saccade/By_Channel_%03ims/',cfg.window_size);
if ~isdir(cfg.path_out)
    mkdir(cfg.path_out)
end
cfg.array_number = [2,4,5];
cfg.array_name = {'PRR','PRR','PRR','PRR','PMd','PMd'};

switch cfg.window_size
    case 32
        cfg.freq = [140 30 60 120]; % 32 ms
        
    case 64
        cfg.freq = [100 15 60 80]; % 64 ms
        
    case 128
        cfg.freq = [100 7 25 60]; % 128 ms
        
    case 256
        cfg.freq = [50 4 20 40]; % 256 ms
        
    case 512
        cfg.freq = [50,1,10,30]; % 512 ms
end

%%
by_channel(f,cfg);

close(f)