function [data_imp, handles] = scoreSleep_jeanLouis2001(data_imp, Ps, handles)

    tic;
    fileName = 'jeanLouisOriginalWeights.mat';
    load(fileName)    
    
    w = jeanLouisOriginalWeights(:,2); % weights
    t = jeanLouisOriginalWeights(:,3); % as samples

    % You first need to scale the activity of your used device to
    % match the 12-bit precision used in the original paper.            
    actScaler = (2^8 - 1) / handles.plotSettings.activity_YLimits(2);

    % You could now either upsample the activity to the 30sec epoch
    % temporal resolution or downsample the weighing function to
    % the activity resolution (given that the epochs recorded are
    % longer than the 30 sec used in the Scripps

    % We now choose to UPSAMPLE the ACTIVITY as there is not that
    % much data points in the weighting function
    upSampleFactor = Ps / 60; % 60 sec in the original paper
    if upSampleFactor ~= 1
        x_i = (linspace(min(data_imp.date), max(data_imp.date), upSampleFactor * length(data_imp.date)))';
        activity_upSampl = interp1(data_imp.date, data_imp.activity, x_i, 'pchip');
        activity = activity_upSampl * actScaler;
    else
        activity = data_imp.activity * actScaler;
    end    
    

    % define start and end index for the FOR loop
    startIndex = 5;
    endIndex = 2;    

    %% SCORE SLEEP
    D = zeros(length(activity),1); 
        for i = startIndex : (length(activity) - endIndex)

            Dtmp = 0;
            for j = 1 : length(w)
                Dtmp = Dtmp + w(j) * activity(i + t(j));
            end        
            D(i) = Dtmp * handles.compSet.scoreSleep_Scripps_scaler;

        end
            
        
    %% Assign to output variables with downsampling
    
        % downsample first       
        if upSampleFactor ~= 1
            D = interp1(x_i, D, data_imp.date);
        end
                
        % then assign
        data_imp.sleep_jeanLouis2001.D = D;
        data_imp.sleep_jeanLouis2001.sleepBoolean = (D < 1);    

    
    handles.timing.sleepScoring_jeanLouis2001 = toc;