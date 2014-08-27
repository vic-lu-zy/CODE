function [Behaviour, Changes] = storeEyeBehaviour(Behaviour, Experiment, FileInfo, Changes)


if 1 %Changes.Behaviour || Changes.Experiment || Changes.FileInfo
    
    %%
    close all;
    
    %%
    
    if exist([FileInfo.fullDataDirectory 'LFPxeye.mat'], 'file')
        LFPxeye = load([FileInfo.fullDataDirectory 'LFPxeye.mat']);
        LFPyeye = load([FileInfo.fullDataDirectory 'LFPyeye.mat']);
        
    elseif exist([FileInfo.fullDataDirectory 'lfpxeye.mat'], 'file')
        LFPxeye = load([FileInfo.fullDataDirectory 'lfpxeye.mat']);
        LFPyeye = load([FileInfo.fullDataDirectory 'lfpyeye.mat']);
    end
    
    if LFPxeye.LFP.rawData.T(1)<1
        % then the sample time is in seconds
        sampleTime_relToBegin = round(min(LFPxeye.LFP.rawData.T*1000)):(round(min(LFPxeye.LFP.rawData.T*1000)) + size(LFPxeye.LFP.rawData.ad, 1) - 1);
    else
        %then it's already in seconds
        sampleTime_relToBegin = round(min(LFPxeye.LFP.rawData.T)):(round(min(LFPxeye.LFP.rawData.T)) + size(LFPxeye.LFP.rawData.ad, 1) - 1);
    end
    
    
    
    %% eliminate off screen gazes
    [Nx,Xx] = hist(LFPxeye.LFP.rawData.ad, 100);
    [Ny,Xy] = hist(LFPyeye.LFP.rawData.ad, 100);
    
    figure;
    subplot(2,1,1);
    bar(Xx,Nx);
    subplot(2,1,2);
    bar(Xy, Ny);
    
    x_max = Xx(end-4); %can tweak these
    x_min = Xx(5);
    
    y_max = Xy(end-4);
    y_min = Xy(5);
    
    figure;
    subplot(2,1,1);
    hold on;
    plot(sampleTime_relToBegin, LFPxeye.LFP.rawData.ad);
    axis tight;
    horzLine(x_max,'r');
    horzLine(x_min,'r');
    hold off;
    
    subplot(2,1,2);
    hold on;
    plot(sampleTime_relToBegin, LFPyeye.LFP.rawData.ad);
    axis tight;
    horzLine(y_max,'r');
    horzLine(y_min,'r');
    hold off;
    
    goodPointsMask = LFPxeye.LFP.rawData.ad > x_min & LFPxeye.LFP.rawData.ad < x_max & LFPyeye.LFP.rawData.ad > y_min & LFPyeye.LFP.rawData.ad < y_max;
    
    LFPxeye.LFP.rawADinterpolated = interp1(sampleTime_relToBegin(goodPointsMask), LFPxeye.LFP.rawData.ad(goodPointsMask), sampleTime_relToBegin,'nearest','extrap');
    LFPyeye.LFP.rawADinterpolated = interp1(sampleTime_relToBegin(goodPointsMask), LFPyeye.LFP.rawData.ad(goodPointsMask), sampleTime_relToBegin,'nearest','extrap');
    
    figure;
    subplot(2,1,1);
    hold on;
    plot(sampleTime_relToBegin, LFPxeye.LFP.rawADinterpolated);
    axis tight;
    horzLine(x_max,'r');
    horzLine(x_min,'r');
    hold off;
    
    subplot(2,1,2);
    hold on;
    plot(sampleTime_relToBegin, LFPyeye.LFP.rawADinterpolated);
    axis tight;
    horzLine(y_max,'r');
    horzLine(y_min,'r');
    hold off;
    
    %% perspective transformation business
    
    [initialEye_unique, ~, initialEye_index] = unique(Experiment.initialEyePosition_byTrial, 'rows');
    [finalEye_unique, ~, finalEye_index] = unique(Experiment.finalEyePosition_byTrial, 'rows');
    
    
    tmp19a = cell(size(initialEye_unique, 1), 2);
    tmp19b = cell(size(finalEye_unique, 1), 2);
    
    for i = 1:Experiment.numTrials
        preTime = Experiment.Times.TrialStart(i) + Experiment.Times.T4(i) - 100;
        postTime = Experiment.Times.TrialStart(i) + Experiment.Times.T8(i) + 300;
        prePeriod = (sampleTime_relToBegin>=preTime-50) & (sampleTime_relToBegin<=preTime+50);
        postPeriod = (sampleTime_relToBegin>=postTime-50) & (sampleTime_relToBegin<=postTime+50);
        
        tmp19a{initialEye_index(i),1} = [tmp19a{initialEye_index(i),1}; mean(LFPxeye.LFP.rawADinterpolated(prePeriod)), mean(LFPyeye.LFP.rawADinterpolated(prePeriod))];
        tmp19a{initialEye_index(i),2} = [tmp19a{initialEye_index(i),2}; i];
        tmp19b{finalEye_index(i),1} = [tmp19b{finalEye_index(i)}; mean(LFPxeye.LFP.rawADinterpolated(postPeriod)), mean(LFPyeye.LFP.rawADinterpolated(postPeriod))];
        tmp19b{finalEye_index(i),2} = [tmp19b{finalEye_index(i),2}; i];
    end
    
    tmp21a = nan(Experiment.numTrials, size(initialEye_unique,1), 2);
    tmp22a = nan(Experiment.numTrials, size(initialEye_unique,1), 2);
    for i = 1:size(tmp19a, 1)
        tmp20a = zscore(tmp19a{i,1},0,1);
        tmp20b = any(tmp20a>2, 2);
        tmp19a{i,1}(tmp20b,:) = [];
        tmp19a{i,2}(tmp20b,:) = [];
        for j = 1:size(tmp19a{i,1}, 2)
            tmp19a{i,1}(:,j) = smooth(tmp19a{i,1}(:,j), 7);
        end
        tmp21a(tmp19a{i,2}, i, :) = tmp19a{i,1};
        if length(tmp19a{i,2})>1
            tmp22a(:, i, :) = interp1(tmp19a{i,2}, tmp19a{i,1}, 1:Experiment.numTrials, 'nearest', 'extrap');
        else
            tmp22a(:, i, :) = repmat(tmp19a{i,1}, Experiment.numTrials, 1);
        end        
    end
    
    tmp21b = nan(Experiment.numTrials, size(finalEye_unique,1), 2);
    tmp22b = nan(Experiment.numTrials, size(finalEye_unique,1), 2);
    for i = 1:size(tmp19b, 1)
        tmp20a = zscore(tmp19b{i,1},0,1);
        tmp20b = any(tmp20a>2, 2);
        tmp19b{i,1}(tmp20b,:) = [];
        tmp19b{i,2}(tmp20b,:) = [];
        for j = 1:size(tmp19b{i,1}, 2)
            tmp19b{i,1}(:,j) = smooth(tmp19b{i,1}(:,j), 7);
        end
        tmp21b(tmp19b{i,2}, i, :) = tmp19b{i,1};
        if length(tmp19b{i,2})>1
            tmp22b(:, i, :) = interp1(tmp19b{i,2}, tmp19b{i,1}, 1:Experiment.numTrials, 'nearest', 'extrap');
        else
            tmp22b(:, i, :) = repmat(tmp19b{i,1}, Experiment.numTrials, 1);
        end        
    end
    
    for i = 1:Experiment.numTrials
        preEyePos_rec(i, :) = tmp22a(i, initialEye_index(i), :);
        postEyePos_rec(i, :) = tmp22b(i, finalEye_index(i), :);
    end
    
    figure;
    subplot(2,2,1);
    hold on;
    plot(tmp21a(:,:,1),'o');
    plot(tmp22a(:,:,1),'-');
    hold off;
    
    subplot(2,2,3);
    hold on;
    plot(tmp21a(:,:,2),'o');
    plot(tmp22a(:,:,2),'-');
    hold off;
    
    subplot(2,2,2);
    hold on;
    plot(tmp21b(:,:,1),'o');
    plot(tmp22b(:,:,1),'-');
    hold off;
    
    subplot(2,2,4);
    hold on;
    plot(tmp21b(:,:,2),'o');
    plot(tmp22b(:,:,2),'-');
    hold off;
    
    %%
    % it might be interesting to use the camera perspective transform here
    % on every trial using the interpolated eye positions
    
    %%
    allTrialsMask = false(size(sampleTime_relToBegin));
    
    m_x = zeros(size(LFPxeye.LFP.rawADinterpolated));
    b_x = zeros(size(LFPxeye.LFP.rawADinterpolated));
    
    m_y = zeros(size(LFPyeye.LFP.rawADinterpolated));
    b_y = zeros(size(LFPyeye.LFP.rawADinterpolated));
    
    
    for i = 1:Experiment.numTrials
        % the ideal eye positions for each trial
        preEyePos_ideal(i,:) = Experiment.initialEyePosition_byTrial(i,:);
        postEyePos_ideal(i,:) = Experiment.finalEyePosition_byTrial(i,:);
        
        preTime(i) = Experiment.Times.TrialStart(i) + Experiment.Times.T4(i) - 100;
        postTime(i) = Experiment.Times.TrialStart(i) + Experiment.Times.T8(i) + 300;
        % % %
        % % %         prePeriod = (sampleTime_relToBegin>=preTime(i)-50) & (sampleTime_relToBegin<=preTime(i)+50);
        % % %         postPeriod = (sampleTime_relToBegin>=postTime(i)-50) & (sampleTime_relToBegin<=postTime(i)+50);
        
        % % %         preEyePos_rec(i,1) = mean(LFPxeye.LFP.rawADinterpolated(prePeriod));
        % % %         preEyePos_rec(i,2) = mean(LFPyeye.LFP.rawADinterpolated(prePeriod));
        % % %
        % % %         postEyePos_rec(i,1) = mean(LFPxeye.LFP.rawADinterpolated(postPeriod));
        % % %         postEyePos_rec(i,2) = mean(LFPyeye.LFP.rawADinterpolated(postPeriod));
        
        trialMask = (sampleTime_relToBegin>=Experiment.Times.TrialStart(i)) & (sampleTime_relToBegin<=Experiment.Times.TrialStart(i)+Experiment.Times.T19(i));
        
        allTrialsMask(trialMask) = true;
        
        
        if (postEyePos_ideal(i,1) - preEyePos_ideal(i,1))==0
            m_x1(i) = 1;
            b_x1(i) = (postEyePos_ideal(i,1) + preEyePos_ideal(i,1) - (postEyePos_rec(i,1) + preEyePos_rec(i,1)))/2;
        else
            m_x1(i) = (postEyePos_ideal(i,1)-preEyePos_ideal(i,1))/(postEyePos_rec(i,1)-preEyePos_rec(i,1));
            b_x1(i) = (postEyePos_ideal(i,1) + preEyePos_ideal(i,1) - m_x1(i)*(postEyePos_rec(i,1) + preEyePos_rec(i,1)))/2;
        end
        
        if (postEyePos_ideal(i,2) - preEyePos_ideal(i,2))==0
            m_y1(i) = 1;
            b_y1(i) = (postEyePos_ideal(i,2) + preEyePos_ideal(i,2) - (postEyePos_rec(i,2) + preEyePos_rec(i,2)))/2;
        else
            m_y1(i) = (postEyePos_ideal(i,2)-preEyePos_ideal(i,2))/(postEyePos_rec(i,2)-preEyePos_rec(i,2));
            b_y1(i) = (postEyePos_ideal(i,2) + preEyePos_ideal(i,2) - m_y1(i)*(postEyePos_rec(i,2) + preEyePos_rec(i,2)))/2;
        end
        
        m_x(trialMask) = m_x1(i);
        b_x(trialMask) = b_x1(i);
        m_y(trialMask) = m_y1(i);
        b_y(trialMask) = b_y1(i);
    end
    
    m_x = interp1(sampleTime_relToBegin(allTrialsMask), m_x(allTrialsMask), sampleTime_relToBegin, 'linear', 'extrap');
    b_x = interp1(sampleTime_relToBegin(allTrialsMask), b_x(allTrialsMask), sampleTime_relToBegin, 'linear', 'extrap');
    
    m_y = interp1(sampleTime_relToBegin(allTrialsMask), m_y(allTrialsMask), sampleTime_relToBegin, 'linear', 'extrap');
    b_y = interp1(sampleTime_relToBegin(allTrialsMask), b_y(allTrialsMask), sampleTime_relToBegin, 'linear', 'extrap');
    
    LFPxeye.LFP.rawADfixed = LFPxeye.LFP.rawADinterpolated.*m_x + b_x;
    LFPyeye.LFP.rawADfixed = LFPyeye.LFP.rawADinterpolated.*m_y + b_y;
    
    
    %%
    
    for i = 1:Experiment.numTrials
        
        tmp1a = (sampleTime_relToBegin>=preTime(i)-200) & (sampleTime_relToBegin<=postTime(i)+200);
        
        tmp2b{i} = LFPxeye.LFP.rawADfixed(tmp1a);
        tmp2c{i} = LFPyeye.LFP.rawADfixed(tmp1a);
        
% % %         figure;
% % %         subplot(2,2,1);
% % %         hold on;
% % %         plot(sampleTime_relToBegin(tmp1a), LFPxeye.LFP.rawADinterpolated(tmp1a),'bo');
% % %         ylim([-12,12]);
% % %         horzLine(preEyePos_rec(i,1),'g');
% % %         horzLine(postEyePos_rec(i,1),'g');
% % %         horzLine(preEyePos_ideal(i,1),'m');
% % %         horzLine(postEyePos_ideal(i,1),'m');
% % %         vertLine(preTime(i),'r');
% % %         vertLine(postTime(i),'r');
% % %         hold off;
% % %         
% % %         subplot(2,2,3);
% % %         hold on;
% % %         plot(sampleTime_relToBegin(tmp1a), LFPyeye.LFP.rawADinterpolated(tmp1a),'bo');
% % %         ylim([-12,12]);
% % %         horzLine(preEyePos_rec(i,2),'g');
% % %         horzLine(postEyePos_rec(i,2),'g');
% % %         horzLine(preEyePos_ideal(i,2),'m');
% % %         horzLine(postEyePos_ideal(i,2),'m');
% % %         vertLine(preTime(i),'r');
% % %         vertLine(postTime(i),'r');
% % %         hold off;
% % %         
% % %         subplot(2,2,2);
% % %         hold on;
% % %         plot(sampleTime_relToBegin(tmp1a), LFPxeye.LFP.rawADfixed(tmp1a),'bo');
% % %         ylim([-12,12]);
% % %         horzLine(preEyePos_rec(i,1),'g');
% % %         horzLine(postEyePos_rec(i,1),'g');
% % %         horzLine(preEyePos_ideal(i,1),'m');
% % %         horzLine(postEyePos_ideal(i,1),'m');
% % %         vertLine(preTime(i),'r');
% % %         vertLine(postTime(i),'r');
% % %         hold off;
% % %         
% % %         subplot(2,2,4);
% % %         hold on;
% % %         plot(sampleTime_relToBegin(tmp1a), LFPyeye.LFP.rawADfixed(tmp1a),'bo');
% % %         ylim([-12,12]);
% % %         horzLine(preEyePos_rec(i,2),'g');
% % %         horzLine(postEyePos_rec(i,2),'g');
% % %         horzLine(preEyePos_ideal(i,2),'m');
% % %         horzLine(postEyePos_ideal(i,2),'m');
% % %         vertLine(preTime(i),'r');
% % %         vertLine(postTime(i),'r');
% % %         hold off;
    end
    
    
    lolz1 = cell2mat(tmp2b);
    lolz2 = cell2mat(tmp2c);
    figure;
    plot(lolz1,lolz2, 'o');
    
    
    %%
    % entire session
    Behaviour.eyePosition(:,1) = LFPxeye.LFP.rawADfixed;
    Behaviour.eyePosition(:,2) = LFPyeye.LFP.rawADfixed;
    Behaviour.sampleTime = sampleTime_relToBegin;
    
    
    saveFigs(FileInfo.arrayDirectory, ['Fix Eye Data ' myNow()]);
    
    close all;
    
    Changes.Behaviour = 1;
end

end