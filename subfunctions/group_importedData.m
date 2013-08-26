function [data_group, data_imp, handles] = group_importedData(data_imp, handles)
        
    %% GROUP THE DATA by the DAY    
    rInd = data_imp.param.uniqRowsInd; % use shorter variable name        
    
    fprintf('    Grouping the data to unique days\n');

    %% go through the data and change to next index when the day changes 
    %% (or after ZT24 or CT24 or as you wish)
    
        % preallocate memory
        % data_group = cell(length(data_imp.param.numberOfDays),1);

        noDays = data_imp.param.numberOfDays; 
        
        for i = 1 : noDays

            if i == 1; startInd = 1; else startInd = rInd(i-1)+1; end
            endInd = rInd(i);             
            % disp(['     Indices: ', num2str(startInd), ' : ', num2str(endInd)]) % debug line
            
            if startInd ~= endInd 
                
                % if the start and end index are the same there is no real
                % data in this bin then, otherwise data is normally added
                % to the cell "data_group"

                data_group{i}.date          = data_imp.date(startInd:endInd);
                data_group{i}.timeOnly      = datenum(data_imp.dateVecPerDay(startInd:endInd, 1:6));  
                data_group{i}.timeInSecond  = data_imp.dateVecPerDay(startInd:endInd, 6)...
                                              + (60 * data_imp.dateVecPerDay(startInd:endInd, 5))...
                                              + (3600 * data_imp.dateVecPerDay(startInd:endInd, 4));

                data_group{i}.activity      = data_imp.activity(startInd:endInd);

                % VIVAGO SPECIFIC
                if strcmp(handles.importSettings.importFrom, 'Vivago') == 1
                    data_group{i}.noData        = data_imp.noData(startInd:endInd);
                    data_group{i}.notOnWrist    = data_imp.notOnWrist(startInd:endInd);
                    data_group{i}.sleep         = data_imp.sleep(startInd:endInd);                
                    data_group{i}.sleepLog      = data_imp.sleepLog.booleanVector(startInd:endInd);
                else
                    data_group{i}.noData        = NaN;
                    data_group{i}.notOnWrist    = NaN;
                    data_group{i}.sleep         = NaN;
                    data_group{i}.sleepLog      = NaN;
                end
                
                % data_group{i}.lightDarkCycle= 
                                
            else
                % Not really a valid day so we reduce it from total number
                % of days
                data_imp.param.numberOfDays = data_imp.param.numberOfDays - 1;                
            end            
            
            %{
            disp('debug')           
            tmp = datevec(data_group{i}.date);                          
            ind = (startInd:1:endInd)';        
            [tmp ind data_group{i}.timeOnly]
            %}
          
        end    
        
        
        