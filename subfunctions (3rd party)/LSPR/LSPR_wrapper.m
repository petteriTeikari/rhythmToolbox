function LSPR_out = LSPR_wrapper(y, y_detr, y_smooth, t, handles)
      

    % ADAPTED from the original code provided by 
    % PETTERI TEIKARI, petteri.teikari@gmail.com, 2011
    
        % Yang, Rendong, Chen Zhang, and Zhen Su. 
        % “LSPR: an integrated periodicity detection algorithm 
        % for unevenly sampled temporal microarray data.” 
        % Bioinformatics (February 3, 2011). 
        % http://dx.doi.org/10.1093/bioinformatics/btr041
        
    % Reassign some variables
    
        % use a default period (i.e. 24 for circadian microarray data) 
        % to do harmonic analysis when no periods could be detected in [lower,upper]
        defaultPeriod = handles.compSet.LSPR.defPeriod;
        
        % endpoints of period range
        lower = handles.compSet.LSPR.periodLower;
        upper = handles.compSet.LSPR.periodUpper;        
        
        % Local CONSTANTS
        FINAL_VAR_NUM = 10;
              

    %% Step 1 : Already done before calling the wrapper, and the results
    %          are provided as inputs to this file
        %          y        - the raw input
        %          y_detr   - the detrended version of the input
        %          y_smooth - the smoothed version of the detrended data
     
        
    %% Step 2 : SPECTRUM ESTIMATION
    noOfmodalities = size(y,2); 
                       % number of different oscillators (or possible oscillators)
                       % in the input data. In the original LSPR code, the
                       % variable noOfmodalities was here referring to number
                       % different genes (probes). If we have only one time
                       % series (e.g. activity) this value is 1                       
    
    % Create two COLUMNS for each intermediate variable (followings) to save values:
    %  - first column saves the intermediate variables of detrendedData after spectrum estimation
    %  - second column saves the intermediate variables of filtereddData (been detrended and filter) after spectrum estimation 
    
        % preallocate memory
        peakSignLayers = zeros(noOfmodalities,1,2); % Mark if any peaks exists in [1/upper,1/lower]
        periodsNumLayers = zeros(noOfmodalities,1,2); % Array of number of different oscillations 
        periodsLayers = cell(noOfmodalities,1,2); % Array of detected periods
        
    % Do spectrum estimation with detrendedData and filteredData, respectively
    fprintf('         LSPR\n');
    fprintf('            Estimating periods with detrended data...\n');        
        k = 1; % For DETRENDED data
        [peakSignLayers(:,1,k),periodsLayers(:,1,k),periodsNumLayers(:,1,k)] = spectrumEstimation(y_detr,lower,upper,defaultPeriod,t,handles);
                
    fprintf('            Estimating periods with detrended and filtered data...\n');        
        k = 2; % For FILTERED/SMOOTHED data
        [peakSignLayers(:,1,k),periodsLayers(:,1,k),periodsNumLayers(:,1,k)] = spectrumEstimation(y_smooth,lower,upper,defaultPeriod,t,handles);        
                
        
    %% Step 3: HARMONIC REGRESSION
    
    % Create two COLUMNS for each intermediate variable (followings) to save values:
    %  - first column saves the intermediate variables of detrendedData after harmonic analysis
    %  - second column saves the intermediate variables of filtereddData after harmonic analysis
    
        % preallocate memory
        rsquaresLayers = zeros(noOfmodalities,1,2);  % Array of R squares
        pvaluesLayers = zeros(noOfmodalities,1,2);   % Array of pvalues
        AICsLayers = zeros(noOfmodalities,1,2);      %  Array of  AICs
        amplitudesLayers = cell(noOfmodalities,1,2); % Array of amplitudes
        phasesLayers = cell(noOfmodalities,1,2);     % Array of phases
        
        % Harmonic analysis with detrendedData and filteredData, respectively
        fprintf('            harmonic regression with detrended data...\n');            
            k = 1; % For DETRENDED data
            [AICsLayers(:,1,k),amplitudesLayers(:,1,k),phasesLayers(:,1,k),rsquaresLayers(:,1,k),pvaluesLayers(:,1,k)] = harmonicRegression(y_detr,t,periodsLayers(:,1,1),periodsNumLayers(:,1,1));
                        
        fprintf('            harmonic regression with detrended and filtered data...\n');            
            k = 2; % For FILTERED/SMOOTHED data
            [AICsLayers(:,1,k),amplitudesLayers(:,1,k),phasesLayers(:,1,k),rsquaresLayers(:,1,k),pvaluesLayers(:,1,k)] = harmonicRegression(y_detr,t,periodsLayers(:,1,2),periodsNumLayers(:,1,2));            
        
    %% Step 4: AIC for best harmonic regression determination
            
        % Choose a better one from two harmonic models according to Akaike information criterion
        % (AIC) and compute corresponding qvalues and FDR-BHs
        Results = cell(noOfmodalities,FINAL_VAR_NUM);% Save output variables
        
        %--------------------------------------------------------------------------
        %      1                   2                   3                   4
        % filter type           method      number of oscillations      period
        %      5                   6                   7                   8
        %  amplitude            phase              R-square             pvalue
        %      9                  10
        %    qvalue             FDR-BH
        %--------------------------------------------------------------------------        
        for iRow=1:noOfmodalities
            
            [~,page] = min(AICsLayers(iRow,1,:));% Find the better model
            
            if(page == 1)
                Results{iRow,1} = -1; % Page of detrended data
            else
                Results{iRow,1} = 1;% Page of detrended and filtered data
            end
            
            if peakSignLayers(iRow,1,page) == 1
                Results{iRow,2}='LSPR';
            else
                Results{iRow,2}='Default';
            end
            
            Results{iRow,3} = periodsNumLayers(iRow,1,page);    % Number of oscillations
            Results{iRow,4} = periodsLayers{iRow,1,page};       % Detected period
            Results{iRow,5} = amplitudesLayers{iRow,1,page};    % Amplitude
            Results{iRow,6} = phasesLayers{iRow,1,page};        % Phase
            Results{iRow,7} = rsquaresLayers(iRow,1,page);      % R-square
            Results{iRow,8} = pvaluesLayers(iRow,1,page);       % Pvalue  
        
            
            % Assigning the results to output structure keeping the 
            % original code as original as possible (Petteri Teikari)
            if noOfmodalities == 1
                LSPR_out.method            = Results{iRow,1};
                LSPR_out.type              = Results{iRow,2};  
                LSPR_out.nrOfOscillations  = periodsNumLayers(iRow,1,page);    % Number of oscillations
                LSPR_out.period            = periodsLayers{iRow,1,page};       % Detected period
                LSPR_out.amplitude         = amplitudesLayers{iRow,1,page};    % Amplitude
                LSPR_out.phase             = phasesLayers{iRow,1,page};        % Phase
                LSPR_out.R2                = rsquaresLayers(iRow,1,page);      % R-square
                LSPR_out.pvalue            = pvaluesLayers(iRow,1,page);       % Pvalue
            end
            
        end
        

        %% Calculate FDR (FDR-BHs, qvalues)
        pvalues = cell2mat(Results(:,8));
        qvalues=[];        
            
            % In some special cases, qvalues cannot be calculated (represented as NaNs).
            % For example, when microarray data contains constant or monotonic time-series,
            % so we suggest to remove them before analyzing
            try
                [~,qvalues] = mafdr(pvalues);
            catch
                qvalues(1:length(pvalues),1) = NaN;% Fail to generate qvalues
            end
            [FdrBHs] = mafdr(pvalues, 'BHFDR', true);

            for iRow=1:noOfmodalities
                Results{iRow,9}=qvalues(iRow); % qvalues
                Results{iRow,10}=FdrBHs(iRow); % FDR-BH
                
                % Assigning the results to output structure keeping the 
                % original code as original as possible (Petteri Teikari)
                if noOfmodalities == 1
                    LSPR_out.qvalue  = qvalues(iRow); % qvalues
                    LSPR_out.FDR_BH  = FdrBHs(iRow);  % FDR-BH
                end
                
            end   
            