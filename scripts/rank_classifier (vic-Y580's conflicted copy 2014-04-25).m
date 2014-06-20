%%
ccc

load cl65
load sac_lfp_onset

trials = (cl==1 | cl==3);
% trials = 1:177;
cl = cl(trials);

%% pmtm
dur = 1:129;
psd = extract_psd(lfp(trials,:,dur));
F = linspace(0,500,size(psd,3));

% %% fft
% dur = 1:256;
% psd = (abs(fft(lfp(trials,:,dur),[],3)));
% F = linspace(0,1000,length(dur));

%% extract feature
X50 = reshape(psd(:,:,2:find(F>=50,1)),size(psd,1),[]);
X300 = reshape(psd(:,:,2:find(F>=300,1)),size(psd,1),[]);
% X50 = uniStd(X50,2); X300 = uniStd(X300,2);
% clear lfp psd
%%
clc

rate(1,1) = lin_classify(X50,cl);
rate(1,2) = kernel_classify(X50,cl);
% rate(2,3) = gaussian_kernel_classify(X50,cl);
[~, rate(1,3)] = svm_classify(X50,cl,'linear');

rate(2,1) = lin_classify(X300,cl);
rate(2,2) = kernel_classify(X300,cl);
% rate(1,3) = gaussian_kernel_classify(X300,cl);
[~, rate(2,3)] = svm_classify(X300,cl,'linear');


rate

