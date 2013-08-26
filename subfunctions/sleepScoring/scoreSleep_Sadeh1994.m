function [data_imp, handles] = scoreSleep_Sadeh1994(data_imp, Ps, handles)

    tic;            

    meanMinutes = 11; sigmaMinutes = 6;
    windowL_samples = (meanMinutes*60) / Ps; % window length in samples
    wL = (windowL_samples - 1)/2; % window limit (for 11 samples, this is 5)
    startIndex = (sigmaMinutes*60) / Ps;
    natL = handles.compSet.scoreSleep_Sadeh_epochCriterion;

    SI = zeros(length(data_imp.activity),1); PS = zeros(length(data_imp.activity),1);
    for i = startIndex : (length(data_imp.activity) - (startIndex) + 1)

        % mu is the mean activity on a 11-min window centered on
        % the current epoch
        mu     = nanmean(data_imp.activity(i-wL:i+wL));

        % sigma is the standard deviation of activity for the last
        % 6 minutes
        sigma  = nanstd(data_imp.activity(i-wL:i));

        % logAct is the natural logarithm of the activity of the
        % current epoch increased by 1
        logAct = log(data_imp.activity(i)) + 1;

        % nat is the number of epochs that satisfy the criterion 
        % 50 <= epoch activity < 100 in an 11-min window centered
        % on the current activity. 50 and 100 values from 2^8
        % values?
        nat    = length((natL(1) <= data_imp.activity(i-wL:i+wL) & ...
                 data_imp.activity(i-wL:i+wL) < natL(2)) == 1);

        SI(i) = 7.601 - (0.065*mu) - (0.056*sigma) - (0.0703*logAct) - (1.08*nat);
        PS(i) = 1 ./ (1 + (exp(-1 * SI(i))));

    end

    data_imp.sleep_sadeh1994.PS = PS;            
    data_imp.sleep_sadeh1994.sleepBoolean = (PS > handles.compSet.scoreSleep_Sadeh_PSthreshold);
    
    handles.timing.sleepScoring_sadeh1994 = toc;