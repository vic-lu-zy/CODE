function TestGPU;

% Example of using GPUs with MDCS.
%
% This code ...
%
% Make sure that your glmnPBS.m file requests a gpu from the scheduler.
% The glmnPBS.m file must always be in your project directory (together with 
% your main matlab script).
%
% Job submission commands:
%
%  >> cluster = parcluster('guillimin')
%  >> glmnPBS.submitTo(cluster)
%


filename='~/output_test_gpu.txt';
outfile = fopen(filename,'w');
fprintf(outfile, 'CALCULATION LOG: \n\n');

%Note: Matlab 2014b contains a bug which causes the first GPU-related
% command to produce an error. We can work-around the bug by creating
% a dummy GPU array before using GPU commands. The following line
% can be commented out for other Matlab releases.
dummyVar = gpuArray(4);

fprintf(outfile, 'Starting CPU calculation...\n');
tic;
Ga = rand(1000,'single');
Gfft = fft(Ga); 
Gb = (real(Gfft) + Ga) * 6;
G = gather(Gb);
t2=toc;


fprintf(outfile, 'Time serial = %12f\n', t2);


fprintf(outfile, 'Starting GPU calculation...\n');
tic;
Ga = rand(1000,'single','gpuArray');
fprintf(outfile, 'Generated gpuArray\n');
Gfft = fft(Ga); 
fprintf(outfile, 'Performed fft\n');
Gb = (real(Gfft) + Ga) * 6;
fprintf(outfile, 'performed operations\n');
G = gather(Gb);
fprintf(outfile, 'Gather successful\n');
t2=toc;


fprintf(outfile, 'Time on GPU = %12f\n', t2);

fprintf(outfile, 'CALCULATIONS DONE ...  \n\n');

fclose(outfile);


