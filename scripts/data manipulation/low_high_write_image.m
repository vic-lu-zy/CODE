f = figure(1);
for trial = 1:413
    low_mid_freq(trial);
    print(f,'-dpng',['figures\Low_High\trial' num2str(trial) '.png'])
end

%%

load cl65

f = figure(1);

for dir = 1:4
    trials = find(cl==dir);
    for i = 1:length(trials)
        low_mid_freq_roi(trials(i));
        print(f,'-dpng',['figures\Low_High\sac_roi\' num2str(dir) '\trial' num2str(trials(i)) '.png'])
    end
end

%%

