% This is file is to test what location is accesible from the Guillimin
% Matlab Interface

str = {'/home/lzvic/',...
    '~/',...
    '~/gs/',...
    '/home/lzvic/gs/',...
    '/gs/project/wns-454-aa/vic'};

%%
f = fopen('~/debugggging.txt','w');
fprintf(f,'debugggging\n\n');
fclose(f);

for i = 1:length(str)
    f = fopen([str{i} 'output_' num2str(i) '.txt'],'w');
    fprintf(f,pwd);
    fclose(f);
end