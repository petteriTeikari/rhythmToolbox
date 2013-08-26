function dataOut = import_actim_Daqtometer(fid, handles) 

    % Start processing line by line
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
  
    dataOut = [];
    
    