    function [handles, importFrom] = detect_theImportFormat(handles)
        
        currDir = pwd;
        
        % DAQTOMETER input can be easily recognized with the .daq extension
            % maybe more advanced recognition could be added if there are
            % conflicts with some filenames?
        if ~isempty(strfind(handles.importSettings.inputFile, '.daq'))
            importFrom = 'Daqtometer RAW';
            return
        end
        
        % If file is from CAMS: Circadian Activity Monitoring System,
        % change to something else if there are other .dat files
        if ~isempty(strfind(handles.importSettings.inputFile, '.dat'))
            importFrom = 'CAMS';
            return
        end
        
        % open the file        
        [fid, msg] = fopen(fullfile(handles.importSettings.inputFolder, handles.importSettings.inputFile));
        if fid == -1; errordlg(msg); end   
        
        % Adapted from:
        % http://www.mathworks.com/support/tech-notes/1400/1402.html

        % FIRST READ the file line by line until numeric data is detected        
        
            % Start processing.
            no_lines = 0;
            line = fgetl(fid); 
            
            if ~isstr(line) %#ok<REMFF1>
                disp('Warning: file contains no header and no data')
            end;
            [data, ncols, errmsg, nxtindex] = sscanf(line, '%f');
            firstLine = line;

            % continue until numeric data is encountered
            while isempty(data) || (nxtindex == 1)                    
                 no_lines = no_lines+1;                                    
                 % Store the last-read line in this variable.
                 eval(['line', num2str(no_lines), '=line;'])
                 line = fgetl(fid);
                 if ~isstr(line)
                     disp('Warning: file contains no data')
                     break
                 end
                 [data, ncols, errmsg, nxtindex] = sscanf(line, '%f');
            end % while

            nxtindex = nxtindex - 1;
        
        % the basic outut from the loop above
        handles.importSettings.activFileParam.headerRows = no_lines;
        firstLine;
        first_DataLine = fgetl(fid);
        
        if strcmp(firstLine, first_DataLine) == 1
            % no header found
        end
        
        % If Vivago is found from the first line the format should be the
        % one used with Vivago wrist actimeter
        if ~isempty(strfind(firstLine, 'Vivago '))
            importFrom = 'Vivago';            
            handles.importSettings.activFileParam.columns = 6;
            handles.importSettings.activFileParam.delimiter = '\t';   
        end        
        
        % If generic time (1st col) and activity (2nd col) file is found
        if handles.importSettings.activFileParam.headerRows == 1
            importFrom = 'Generic_TimeActivity';                      
            handles.importSettings.activFileParam.columns = 2;
            handles.importSettings.activFileParam.delimiter = '\t';   
            
            % determining the time format            
        end       
        
        cd(currDir)