function [sleepLog, handles] = import_sleepLog_petteri(handles, date, param)

    handles.fileNameSleepLog = sprintf('%s%s%s%s', 'sleepLog_', handles.fileNameWoExt, '.', handles.importSettings.sleepLogParam.format);                
    currDir = pwd; 
    
    fid = fopen(fullfile(handles.path.dataSleepLogs, handles.fileNameSleepLog));
    if fid == -1 % no file found
        return
    end
    sleepLog_raw = textscan(fid, '%s %s %s %s', 'Delimiter', handles.importSettings.sleepLogParam.delimiter, 'HeaderLines', handles.importSettings.sleepLogParam.headerRows);                           
    fclose(fid);

    % separate the columns

        % INPUT
        % 1st column - DATE
        % 2nd column - SLEEP TIME
        % 3rd column - WAKE TIME
        % 4th column - COMMENTS

        % output has only three columns: 
        % 1) SLEEP DATE/TIME
        % 2) WAKE DATE/TIME
        % 3) COMMENTS                    

        % preallocate vectors
        dateVec  = zeros(length(sleepLog_raw{1}), 3);
        sleepVec = zeros(length(sleepLog_raw{1}), 3);
        wakeVec  = zeros(length(sleepLog_raw{1}), 3);
        for i = 1 : length(sleepLog_raw{1})                        

            % separate the rows years, months, days
            dateRaw = textscan(sleepLog_raw{1}{i}, '%d%d%d', 'Delimiter', '/');                                                                   
                dateVec(i,1:3) = [dateRaw{3} dateRaw{2} dateRaw{1}];    

            % separate the sleep rows into hours and minutes                        
            if isempty(sleepLog_raw{2}{i}); sleepLog_raw{2}{i} = 'NaN'; end
            sleepRaw = textscan(sleepLog_raw{2}{i}, '%d%d', 'Delimiter', ':');
                if isempty(sleepRaw{2})
                    sleepVec(i,1:3) = [NaN NaN NaN];                            
                else
                    sleepVec(i,1:3) = [sleepRaw{1} sleepRaw{2} 0];    
                end

            % separate the wake rows into hours and minutes
            if isempty(sleepLog_raw{3}{i}); sleepLog_raw{3}{i} = 'NaN'; end
            wakeRaw = textscan(sleepLog_raw{3}{i}, '%d%d', 'Delimiter', ':');                             
                if isempty(wakeRaw{2})
                    wakeVec(i,1:3) = [NaN NaN NaN];                            
                else
                    wakeVec(i,1:3) = [wakeRaw{1} wakeRaw{2} 0];                            
                end
        end

        % get the indices corresponding to non-NaN-rows
        sleepVec_nonNan_ind = ~isnan(sleepVec(:,1));
        wakeVec_nonNan_ind  = ~isnan(wakeVec(:,1));

        % create vectors corresponding to the individual
        % sleep and wake times as datevec (includes the data)
        sleepLog.sleep_vec = [dateVec(sleepVec_nonNan_ind,:) sleepVec(sleepVec_nonNan_ind,:)];
        sleepLog.wake_vec = [dateVec(wakeVec_nonNan_ind,:) wakeVec(wakeVec_nonNan_ind,:)];                    

        % create a boolean vector matching thetemporal
        % resolution of the actimeter so that it could be used
        % for differential analysis of the sleep / wake periods
        sleepLog.booleanVector = zeros(param.lengthOfActivity,1); % match the length of the activity
                      
        % check the dates of the Vivago data
        loopEnd = min([length(sleepLog.sleep_vec) length(sleepLog.wake_vec)]);
        
        for i = 1 : loopEnd            
            ind1 = find(date - datenum(sleepLog.sleep_vec(i,:)) == 0);
            ind2 = find(date - datenum(sleepLog.wake_vec(i,:)) == 0);        
            sleepLog.booleanVector(ind1:ind2) = 1;
            
            if ~isempty(ind1)
                sleepLog.indices(:,1:2) = [ind1 ind2];                
            else
                sleepLog.indices(:,1:2) = [NaN NaN];                
            end
            
        end
        
        % convert from double to logical (BOOLEAN)        
        sleepLog.booleanVector = sleepLog.booleanVector == 1;        
        
    cd(currDir)
