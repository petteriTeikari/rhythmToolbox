function [data_imp, handles] = compute_sleepScoring(handles, data_imp)

    % IF SLEEP IS SCORED AT ALL
    if handles.compSet.scoreSleep_ON == 1        
        cd(handles.path.sleepScoring)       
        fprintf('    Scoring Sleep\n');
        
        % use shorter variable name for sampling period
        Ps = data_imp.param.activity_temporalResolution; % in seconds                
        
        %% Sadeh et al. (1994) Algorithm
        if handles.compSet.scoreSleep_Sadeh == 1
            fprintf('     Sadeh et al. 1994 algorithm\n');
            [data_imp, handles] = scoreSleep_Sadeh1994(data_imp, Ps, handles);                       
        end        
        
        %% Jean-Louis et al. (2001) Algorithm
        if handles.compSet.scoreSleep_JeanLouis == 1
            fprintf('      Jean-Louis et al. 2001 algorithm\n');
            [data_imp, handles] = scoreSleep_jeanLouis2001(data_imp, Ps, handles);                       
        end
        
        %% Sazonov et al. (2004) algorithm
        if handles.compSet.scoreSleep_Sazonov == 1           
            fprintf('       Sazonov et al. 2004 algorithm\n');
            [data_imp, handles] = scoreSleep_Sazonov2004(data_imp, Ps, handles);
        end        
        
        %% Kripke et al. (2010), aka Scripps Clinic Algorithm
        if handles.compSet.scoreSleep_Scripps == 1
            fprintf('        Kripke et al. 2010 algorithm\n');
            [data_imp, handles] = scoreSleep_Scripps2010(data_imp, Ps, handles);               
        end
            
        cd(handles.path.subfunctions)
                
    else
        handles.timing.sleepScoring = 0;        
    end          
    
    % disp(' '); disp(handles.timing); disp(' '); 
    