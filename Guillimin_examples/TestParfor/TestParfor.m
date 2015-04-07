function TestParfor;

% Example of using parfor loop.
%
% This code generates 10 random 4000x4000 complex matrices, and then 
% performs their inversion one-by-one in a standard "for" loop, or
% in parallel using "parfor" loop. Only loop is splitted between cores, 
% and each core works on a full matrix at a time.
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
%  (5 is a sample matlabpool size. In this case total number of cores must
%  be 6)




clear all;


N=400;

filename='output_test_parfor.txt';
outfile = fopen(filename,'w');
fprintf(outfile, 'CALCULATION LOG: \n\n');

tic;
for k=1:10
   Ham(:,:,k)=rand(N)+i*rand(N);
   fprintf(outfile,'Serial: Doing K-point : %3i\n', k);
   inv(Ham(:,:,k));
end
t2=toc;

fprintf(outfile, 'Time serial = %12f\n', t2);
fclose(outfile);

tic;
parfor k=1:10
   Ham(:,:,k)=rand(N)+i*rand(N);
   outfile = fopen(filename,'a');
   fprintf(outfile,'Parallel: Doing K-point : %3i\n', k);
   fclose(outfile);
   inv(Ham(:,:,k));
end

t2=toc;
outfile = fopen(filename,'a');

fprintf(outfile, 'Time parallel = %12f\n', t2);
fprintf(outfile, 'CALCULATIONS DONE ...  \n\n');

fclose(outfile);


