% SUBFUNCTION FOR THE VIVAGO IMPORT
    function [data, handles] = import_actim_Vivago(fid, handles)               
           
        % Describe the data in the file with format specifiers, such as '%s' for a string, '%d' for an integer, 
        % or '%f' for a floating-point number. (For a complete list of specifiers, see the fscanf reference page.)  
        tic
        impTemp = textscan(fid, '%s %s %d %d %d %d', 'Delimiter', handles.importSettings.activFileParam.delimiter, 'HeaderLines', handles.importSettings.activFileParam.headerRows);
        handles.timing.vivagoRead = toc;                

            % The Vivago format has 6 columns with the following properties
            
                % 1st column - Date
                % 2nd column - Time
                % 3rd column - Activity (integer, signed 8 bits)
                % 4th column - No data, BOOLEAN
                % 5th column - Not on wrist, BOOLEAN
                % 6th column - Sleep, BOOLEAN

            % Create a 5-column OUTPUT matrix with all in numeric format. 

                % FIRST: Fuse Date and Time and convert to date serial
                % number which is easily manipulated by Matlab                                          

                % THIS APPROACH IS INEFFICIENT computationwise, could be
                % fixed in the future (better way to manipulate strings,
                % dates)
                    
                endLoop = length(impTemp{1});
                tic;
                
                % initialize date vector
                date = zeros(endLoop,1);
                
                % use different variable names to avoid warnings with parfor
                dateStr = impTemp{1};
                timeString = impTemp{2};                
                                
                parfor i = 1 : endLoop                    
                    
                    dateTmp = textscan((dateStr{i}),        '%s%s%s', 'Delimiter', '/');
                    timeTmp = textscan((timeString{i}),     '%s%s%s', 'Delimiter', ':');                      
                    timeTmp2 = textscan(cell2mat(timeTmp{3}), '%s%s', 'Delimiter', ' '); % the timeTmp{2} has either AM or PM
                    timeTmp{3} = timeTmp2{1}; AM_or_PM = timeTmp2{2};
                   
                    year = str2double(dateTmp{3}); month = str2double(dateTmp{1});  day = str2double(dateTmp{2});     % DATE                
                    hour = str2double(timeTmp{1}); minute = str2double(timeTmp{2}); second = str2double(timeTmp{3}); % TIME                    
                    
                    if strcmp(AM_or_PM, 'PM')
                        date(i) = datenum([year month day hour+12 minute second]);
                    else
                        date(i) = datenum([year month day hour minute second]);
                    end                                      
                   
                end       
                
                if handles.importSettings.rejectOutliers == 1
                    % create a boolean matrix with 1's corresponding to
                    % artifacts
                    artifactsBoolean = ~(impTemp{3} == -1); % with value -1 
                else
                    artifactsBoolean = ones(length(impTemp{3}),1);
                end                    
                
                data.date = date(artifactsBoolean); % in serial number format   
                
                % sort the unique row indices just in case there is a problem                     
                [data.date, indImpSorted] = sortrows(data.date); % for some reason Vivago data was not that sorted?
                
                % get the temporal resolution of the data assuming even
                % spacing of the time points
                data.param.activity_temporalResolution = etime(datevec(date(2)), datevec(date(1)));
                
                handles.timing.vivagoDateManip = toc;                
                
            tic;
            % the activity                   
            data.activity = int8(impTemp{3}(artifactsBoolean)); % convert to int8 to reduce memory load
            data.activity = data.activity(indImpSorted); % sort the data

            % NO data, BOOLEAN / LOGICAL                                    
            data.noData = (impTemp{4}(artifactsBoolean)) == 1;
            data.noData = data.noData(indImpSorted); % sort the data
            
            % not on wrist, BOOLEAN / LOGICAL             
            data.notOnWrist = (impTemp{5}(artifactsBoolean)) == 1;
            data.notOnWrist = data.notOnWrist(indImpSorted); % sort the data
            
            % SLEEP, BOOLEAN / LOGICAL             
            data.sleep = impTemp{6}((artifactsBoolean)) == 1;
            data.sleep = data.sleep(indImpSorted); % sort the data                                
