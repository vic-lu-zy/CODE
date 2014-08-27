%%
ccc

load cl65
load sac_lfp_onset

% ind = find(cl==1 | cl==3);
ind = 1:size(lfp,1);
trials = ind(repartition(cl(ind),'min'))';
cl = cl(trials);

%% pmtm
dur1 = 1:129;
psd1 = extract_psd(lfp(trials,:,dur1));
F1 = linspace(0,500,length(dur1));

dur2 = 1:257;
psd2 = extract_psd(lfp(trials,:,dur2));
F2 = linspace(0,500,length(dur2));

% %% fft
% dur = 1:256;
% psd = (abs(fft(lfp(trials,:,dur),[],3)));
% F = linspace(0,1000,length(dur));

% extract feature
X11 = reshape(psd1(:,:,2:find(F1>=50,1)),size(psd1,1),[]);
X12 = reshape(psd1(:,:,2:find(F1>=300,1)),size(psd1,1),[]);
X21 = reshape(psd2(:,:,2:find(F2>=50,1)),size(psd2,1),[]);
X22 = reshape(psd2(:,:,2:find(F2>=300,1)),size(psd2,1),[]);

%%
clc
clear rate
rate(1,1) = lin_classify(X11,cl);
rate(1,2) = kernel_classify(X11,cl);
rate(1,3) = svm_classify(X11,cl,'linear','');

rate(2,1) = lin_classify(X12,cl);
rate(2,2) = kernel_classify(X12,cl);
rate(2,3) = svm_classify(X12,cl,'linear','');

rate(3,1) = lin_classify(X21,cl);
rate(3,2) = kernel_classify(X21,cl);
rate(3,3) = svm_classify(X21,cl,'linear','');

rate(4,1) = lin_classify(X22,cl);
rate(4,2) = kernel_classify(X22,cl);
rate(4,3) = svm_classify(X22,cl,'linear','');

rate

%%
range = 1:100;

f{1} = @(x)svm_classify(X11,cl,'rbf',x);
f{2} = @(x)svm_classify(X12,cl,'rbf',x);
f{3} = @(x)svm_classify(X21,cl,'rbf',x);
f{4} = @(x)svm_classify(X22,cl,'rbf',x);

for i = 1:4
    tic
    rate(i,:) = arrayfun(f{i},range);
    toc
end

%%
clc
clear rate
tic
rate(1,1) = svm_classify(X11,cl,@(u,v)corr(u',v'),'');
rate(1,2) = svm_classify(X11,cl,@(u,v)ssd(u,v),'');
rate(1,3) = svm_classify(X11,cl,'linear','');
rate(2,1) = svm_classify(X12,cl,@(u,v)corr(u',v'),'');
rate(2,2) = svm_classify(X12,cl,@(u,v)ssd(u,v),'');
rate(2,3) = svm_classify(X12,cl,'linear','');
rate(3,1) = svm_classify(X21,cl,@(u,v)corr(u',v'),'');
rate(3,2) = svm_classify(X21,cl,@(u,v)ssd(u,v),'');
rate(3,3) = svm_classify(X21,cl,'linear','');
rate(4,1) = svm_classify(X22,cl,@(u,v)corr(u',v'),'');
rate(4,2) = svm_classify(X22,cl,@(u,v)ssd(u,v),'');
rate(4,3) = svm_classify(X22,cl,'linear','');
toc