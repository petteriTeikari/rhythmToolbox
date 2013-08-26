function [data_imp, handles] = scoreSleep_Scripps2010(data_imp, Ps, handles)

    tic;
    fileName = 'scrippsOriginalWeights.mat';
    load(fileName)
    w = scrippsOriginalWeights(:,2); % weights
    t = scrippsOriginalWeights(:,3); % as samples

    % You first need to scale the activity of your used device to
    % match the 12-bit precision used in the original paper.            
    actScaler = (2^12 - 1) / handles.plotSettings.activity_YLimits(2);

    % You could now either upsample the activity to the 30sec epoch
    % temporal resolution or downsample the weighing function to
    % the activity resolution (given that the epochs recorded are
    % longer than the 30 sec used in the Scripps

    % We now choose to UPSAMPLE the ACTIVITY as there is not that
    % much data points in the weighting function
    upSampleFactor = Ps / 30; % 30 sec in the original paper
    if upSampleFactor ~= 1
        x_i = (linspace(min(data_imp.date), max(data_imp.date), upSampleFactor * length(data_imp.date)))';
        activity_upSampl = interp1(data_imp.date, data_imp.activity, x_i, 'pchip');
        activity = activity_upSampl * actScaler;
    else
        activity = data_imp.activity * actScaler;
    end    

    % define start and end index for the FOR loop
    startIndex = 11;
    endIndex = 3;   
    

    %% SCORE SLEEP
    D = zeros(length(activity),1); 
        for i = startIndex : (length(activity) - endIndex)

            Dtmp = 0;
            for j = 1 : length(w)
                Dtmp = Dtmp + w(j) * activity(i + t(j));
            end        
            D(i) = Dtmp * handles.compSet.scoreSleep_Scripps_scaler;

        end

    %% POST-SCORE SLEEP
    % 10 consecutive epochs need to be over 1
    epochs = handles.compSet.scoreSleep_Scripps_postScoreThr;

    allEpochsOverThr = zeros(length(activity),1);
        for i = (epochs + 1) : (length(activity))
            allEpochsOverThr(i) = 1;
            
            for j = 1 : epochs
               
               if D(i-j) >= 1
                   allEpochsOverThr(i) = 0;
               end
            end
        end
        
        
    %% Assign to output variables with downsampling
    
        % downsample first
        if upSampleFactor ~= 1
            D                = interp1(x_i, D, data_imp.date);
            allEpochsOverThr = interp1(x_i, allEpochsOverThr, data_imp.date);
        end
        
        % then assign
        data_imp.sleep_scripps2010.D = D;
        data_imp.sleep_scripps2010.sleepBoolean = (D < 1);    
        data_imp.sleep_scripps2010.sleepBoolean_w_postScoring = allEpochsOverThr;
        
        %{
        figure
        subplot(3,1,1); area(D); % xlim([7560 7760])
        subplot(3,1,2); area(data_imp.sleep_scripps2010.sleepBoolean); % xlim([7560 7760])
        subplot(3,1,3); area(data_imp.sleep_scripps2010.sleepBoolean_w_postScoring); % xlim([7560 7760])
        %}

    handles.timing.sleepScoring_Scripps2010 = toc;