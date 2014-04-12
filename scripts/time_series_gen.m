f = figure
for elec = 1:48
    timeSeriesTuning_timeOnly(elec,65,f)
        print(f,'-dpng',['D:\Documents\Dropbox\thesis\figures\Time Series\SAC - E' num2str(elec) '.png'])

    timeSeriesTuning_timeOnly(elec,66,f)
        print(f,'-dpng',['D:\Documents\Dropbox\thesis\figures\Time Series\PUR - E' num2str(elec) '.png'])

end