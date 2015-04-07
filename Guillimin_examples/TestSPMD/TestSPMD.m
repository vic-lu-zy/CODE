function TestSPMD;

% Example of using SPMD option.
%
% This code generates random 10000x10000 complex matrix, and then 
% performs its inversion in parallel on several number of workers using the
% spmd directive. For comparison, the same matrix is later inverted on 1
% worker only.
% 
% This example also shows how to include in your job externally defined 
% functions (or data files). 
%
% Use moab.mat file to set the number of nodes and processors per node 
% (ppn) for your job, as well as requested walltime for the job.
% Make sure that total number of reserved cores (nodes*ppn) is equal or
% larger than matlabpool+1.
% The moab.mat file must always be in your project directory (together with 
% your main matlab script).
%
% Job submission commands:
%
%  >> cluster = parcluster('guillimin')
%  >> glmnPBS.submitTo(cluster)
%
%  5 is a sample matlabpool size. In this case total number of cores must
%  be 6. The 'AttachedFiles' option is used to send the content of "data"
%  folder to the cluster to be used in your job (can be matlab scripts or 
%  data files)

clear all;


N=10000;

filename='~/output_test_spmd.txt';
outfile = fopen(filename,'w');
fprintf(outfile, 'CALCULATION LOG: \n\n');


H=Ham(N);

H1=distributed(H);


%deye = distributed.eye(N); 

tic;
spmd
    %X = H\deye; % explicitly compute the inverse
    inv(H1);
end
t2=toc;

fprintf(outfile, 'Time parallel = %12f\n', t2);

%leye=eye(N);

tic;
%lx = Ham\leye;
inv(H);
t2=toc;

fprintf(outfile, 'Time serial = %12f\n', t2);


fprintf(outfile, 'CALCULATIONS DONE ...  \n\n');

fclose(outfile);


