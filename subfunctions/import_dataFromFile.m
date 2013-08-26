function [dataOut, handles] = import_dataFromFile(handles)	

    % tries to automatically to detect the import format
    currDir = pwd;
    [handles, handles.importSettings.importFrom] = detect_theImportFormat(handles);
    fprintf('    Importing from the file\n');    
    
        
    %% determine whether sleep log want to be imported
        if handles.importSettings.importSleepLog == 1;
           if strcmp(handles.importSettings.SleepLogFormat, 'petteri') == 1           
               handles.importSettings.sleepLogParam.headerRows = 1;
               handles.importSettings.sleepLogParam.columns = 4;
               handles.importSettings.sleepLogParam.delimiter = '\t';    
               handles.importSettings.sleepLogParam.format = 'txt';
               
           else
               warndlg('This SLEEP LOG format not speficied in the "import_dataFromFile.m"')        
           end        
        end
    
    
    %% Import the data now from the specified file
        cd(handles.importSettings.inputFolder)                
        fid = fopen(handles.importSettings.inputFile); % opens the file filename for read access, and returns an integer file identifier       
        handles.fileNameWoExt = strrep(strrep(handles.importSettings.inputFile, '.TXT', ''), '.txt', '');
        handles.fileNameWoExt = strrep(handles.fileNameWoExt, '.daq', '');
        handles.fileNameWoExt = strrep(handles.fileNameWoExt, '.dat', '');
        handles.fileNameOutMat = sprintf('%s%s', handles.fileNameWoExt, '.mat');
        disp(['      File: ', handles.importSettings.inputFile])
        
        
        %% VIVAGO FORMAT
        if strcmp(handles.importSettings.importFrom, 'Vivago') == 1         
                        
            if strcmp(handles.importSettings.import_fileFormat, 'txt') == 1
                cd(handles.path.subfunctions)
                dataOut = import_actim_Vivago(fid, handles);      
                cd(handles.importSettings.inputFolder)   
                save(handles.fileNameOutMat, 'dataOut')
                fclose(fid);
                
            else
                cd(handles.importSettings.inputFolder)   
                load(handles.fileNameOutMat)                         
                
            end
                    
            
            
        %% CAMS: Circadian Activity Monitoring System
        elseif strcmp(handles.importSettings.importFrom, 'CAMS') == 1   
            
            if strcmp(handles.importSettings.import_fileFormat, 'txt') == 1
                tic;
                cd(handles.path.subfunctions)
                fclose(fid);                
                dataOut = import_actim_CAMS(handles.importSettings.inputFile, handles.importSettings.inputFolder);      
                cd(handles.importSettings.inputFolder)   
                toc
                save(handles.fileNameOutMat, 'dataOut')
                pause

            else
                cd(handles.importSettings.inputFolder)   
                load(handles.fileNameOutMat)                         
                
            end
        
            
        %% DAQTOMETER        
        elseif strcmp(handles.importSettings.importFrom, 'Daqtometer RAW') == 1   
            
            if strcmp(handles.importSettings.import_fileFormat, 'txt') == 1
                cd(handles.path.subfunctions)
                dataOut = import_actim_Daqtometer(fid, handles);      
                cd(handles.importSettings.inputFolder)   
                save(handles.fileNameOutMat, 'dataOut')
                fclose(fid);
                
            else
                cd(handles.importSettings.inputFolder)   
                load(handles.fileNameOutMat)                         
                
            end                        
        
            
        %% GENERIC TIME(1st col) ACTIVITY(2nd col) format
        elseif strcmp(handles.importSettings.importFrom, 'Generic_TimeActivity') == 1
            
            if strcmp(handles.importSettings.import_fileFormat, 'txt') == 1
                cd(handles.path.subfunctions)
                dataOut = import_actim_generic(handles.importSettings.inputFile, handles);      
                cd(handles.importSettings.inputFolder)   
                save(handles.fileNameOutMat, 'dataOut')
                fclose(fid);
                
            else
                cd(handles.importSettings.inputFolder)   
                load(handles.fileNameOutMat)                         
                
            end
            
        else
                
        end
        
        tic;
        
        % if the activity is INTEGER it is converted to DOUBLE
        if isinteger(dataOut.activity)
            dataOut.activity = double(dataOut.activity);
        end
       
        % define the number of unique days in the data       
        tmp = datevec(dataOut.date);
        [dataOut.param.uniqRows dataOut.param.uniqRowsInd] = unique([tmp(:,1) tmp(:,2) tmp(:,3)], 'rows');       
        dataOut.param.numberOfDays = length(dataOut.param.uniqRows); 
              
        % vectorize the serial number time
        tmpTime = datevec(dataOut.date);
   
        % Use only THE TIME for the grouping and not the DATE, so the DATE is
        % put to be the same for all of the time samples
        dataOut.dateVecPerDay = [ones(length(tmpTime),1) ones(length(tmpTime),1) ones(length(tmpTime),1),...
                                  tmpTime(:,4)            tmpTime(:,5)            tmpTime(:,6)];         

        % Convert back to serial number
        dataOut.dateNumPerDay = datenum(dataOut.dateVecPerDay);        
      
        % get the amount of data samples in the activity data
        dataOut.param.lengthOfActivity   = length(dataOut.activity);
        dataOut.param.totalTimeInSeconds = etime(tmp(end,:), tmp(1,:));          
        
        % create a vector with seconds from the start
        % in case for nonuniform sampling simple vector creating with
        % LINSPACE cannot be used
        t1 = tmp(1,:); t1repmat = repmat(t1,length(tmp),1);
        t2 = tmp(:,:);     
        dataOut.param.timeVectorSeconds = etime(t2,t1repmat);
        
        % set the y-axis limits automagically
        handles.plotSettings.activity_YLimits   = [0 max(dataOut.activity)];
        
        
        handles.timing.generalImportManipulations = toc;
        
    %% Import the sleep log information
    
        if handles.importSettings.importSleepLog == 1 && strcmp(handles.importSettings.importFrom, 'Vivago') == 1
            
            if strcmp(handles.importSettings.SleepLogFormat, 'petteri') == 1
                cd(handles.path.subfunctions)
                [dataOut.sleepLog, handles] = import_sleepLog_petteri(handles, dataOut.date, dataOut.param);                
                cd(handles.path.subfunctions)
            end                
            
        end
    
        disp(['        Number of unique days found from the file: ', num2str(dataOut.param.numberOfDays)])
        
    

        
    % timing
    % handles.timing
    cd(currDir)    