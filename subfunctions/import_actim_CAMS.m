function dataOut = import_actim_CAMS(filename, path, fromMAT, reCompress, saveAsMAT)    

    % Petteri Teikari, petteri.teikari@gmail.com, v. 10/04/2011   
    
    % if no reCompress-flag is given then the default value is used
    if nargin == 2
        fromMAT    = 0;
        reCompress = 0;
        saveAsMAT  = 1;
    elseif nargin == 3
        reCompress = 0;
        saveAsMAT  = 1;
    elseif nargin == 4
        saveAsMAT  = 1;        
    else
        errordlg('You must provide the input filename and the path where this input file is found!')
    end
    
    % parameters
    filename_woExt   = strrep(filename, '.dat', '');
    filename_out_mat1 = [filename_woExt, '_CAMS_origReCompr', '.mat'];
    filename_out_mat2 = [filename_woExt, '_CAMS_orig', '.mat'];
    currDir = pwd;

    %% DROM CAMS system    
    % Each hour record is contained in 82 bytes (binary code). 
    % The header (22 bytes) contains information on animal, date, captor). 
    % The last 60 bytes contains 1 hour of data (1 byte per minute bin). 
    % Each data file contains n records (where n is the number of hours).

    % A value of 0 indicates no counts. The value 255 is 
    % reserved for absence of data (power or system off). 
    % Presence of 255 appears in the actogram as a red line.      
    headerCaptions  = {'Channel Name',...
                       'Date',...
                       'Hour',...
                       'Reserved',...
                       'Channel Type',...
                       'Reserved',...
                       'Channel Number'};   
        
    if fromMAT == 0 % if the file is once already imported you 
                    % can skip this part and read directly from the MAT-file
                   
        %% IMPORT the RAW format    
        cd(path) 
        fid = fopen(filename);       
        A = fread(fid, [82 inf], '*uint8'); % raw import to determine the length of file
        lengthOfInput = length(A);
        fclose(fid);

        %% Import row per row
        fid = fopen(filename);                

            % Preallocate the vectors/matrices
            dataIn.activity = uint8(zeros(lengthOfInput, 60));
            dataIn.chName   = uint8(zeros(lengthOfInput, 8));        
            dataIn.date     = uint8(zeros(lengthOfInput, 3));
            dataIn.hour     = uint8(zeros(lengthOfInput, 1));
            dataIn.res1     = uint8(zeros(lengthOfInput, 1));
            dataIn.chType   = uint8(zeros(lengthOfInput, 1));
            dataIn.res2     = uint8(zeros(lengthOfInput, 1));
            dataIn.chNo     = uint16(zeros(lengthOfInput, 1));

            % if recompression is wanted then those vectors/matrices are also
            % preallocated
            if reCompress == 1
                dataIn.chNameComprChar = uint8(zeros(lengthOfInput, 1));
                dataIn.chNameComprNr   = uint16(zeros(lengthOfInput, 1));
                dataIn.dateCompr       = uint8(zeros(lengthOfInput, 3));
            end

            % Start the processing row by row
            emptyLines = 0;
            for i = 1 : lengthOfInput                      

               %% Channel name
               tmp            = fread(fid,8,'char*1');           

               if length(tmp) == 1 % the last line is normally blank?    
                   emptyLines = (lengthOfInput + 1) - i;
                   break
               end

               if isempty(tmp)
                   tmp = NaN; 
               else
                   % remove blanks (character is 32 in 8-bit ASCII)
                   % charStr = tmp(tmp ~= 32); % could be saved here as RLE number     
               end
               dataIn.chName(i,1:8) = uint8(tmp');

               % express the first character still as a character but the
               % second character is a number corresponding to the channel
               % number ("record from up to 448 channels") which can be
               % expressed as uint16
               if reCompress == 1
                    dataIn.chNameComprChar(i,1) = uint8(tmp(1));
                    dataIn.chNameComprNr(i,1)   = uint16(str2double(char(tmp(2))));
               end


               %% Date
               tmp     = fread(fid,8,'char*1');
               charStr = char(tmp)';     

               if isempty(charStr);
                   dateMat = NaN;
               else
                   % split into year, month, day                      
                   dateCell = textscan(charStr, '%d%d%d', 'Delimiter', '/'); % month/day/year
                   dateMat = [dateCell{3} dateCell{1} dateCell{2}];                 

                   % correct the year
                   if dateMat(1) < 90 % for years under 90, i.e. between 1900-1989, and 2000 ->
                       dateMat(1) = dateMat(1) + 2000;
                   else 
                       dateMat(1) = dateMat(1) + 1900;
                   end

               end
               dataIn.date(i,1:3) = uint16(dateMat);           

               % Like it was with the channel name, some bytes can be saved as
               % expressing the date as year (uint8) month (uint8) day (uint8)
               if reCompress == 1
                    dataIn.dateCompr(i, 1:3) = [uint8(dateCell{3}) uint8(dateCell{1}) uint8(dateCell{2})];           
               end


               %% Hour
               tmp            = fread(fid,1,'*uint8');
               if isempty(tmp); tmp = NaN; end                        
               dataIn.hour(i,1) = tmp;           

               %% Reserved
               tmp            = fread(fid,1,'*uint8');
               if isempty(tmp); tmp = NaN; end                        
               dataIn.res1(i,1) = tmp;

               %% Channel type
               tmp            = fread(fid,1,'*uint8');
               if isempty(tmp); tmp = NaN; end                        
               dataIn.chType(i,1) = tmp;           

               %% Reserved
               tmp            = fread(fid,1,'*uint8');
               if isempty(tmp); tmp = NaN; end                        
               dataIn.res2(i,1) = tmp;


               %% Channel number
               tmp            = fread(fid,1,'*uint16');
               if isempty(tmp); tmp = NaN; end                        
               dataIn.chNo(i,1) = tmp;     


               %% Activities
               actTmp         = fread(fid,60,'*uint8')'; 
               if isempty(actTmp); actTmp = NaN; end   
               dataIn.activity(i, 1:(length(actTmp))) = actTmp;

               % display progress
               if rem(i,1000) == 0; disp(['        .. line: ', num2str(i), '/', num2str(lengthOfInput)]); end                       




            end
            fclose(fid);

            % if empty lines were found then the output size is different from
            % the input        
            lengthOfOutput = lengthOfInput - emptyLines;                                     

            % If recompress was wanted, then the optimized values are saved as 
            % binary file and if saveAsMAT flag was set then also as compressed
            % MAT-file        
            if reCompress == 1                          

                % BINARY not implemented at the moment

                % save as binary, ignore the reserved fields            
                %{
                filename_out_bin = [filename_woExt, '_origReCompr', '.dat'];
                fid = fopen(filename_out_bin, 'w');            

                % to write multiple precision vectors, we could use uwrite/uread by
                % Sridhar Anandakrishnan, http://www.mathworks.com/matlabcentral/fileexchange/2055-uwriteuread            
                % see also: http://www.mathworks.com/matlabcentral/newsreader/view_thread/94508            
                fwrite(fid, , 'integer*1');
                fclose(fid);
                %}            

                if saveAsMAT == 1

                    % save as MAT, ignore the reserved fields                    

                        % create a new structure to be written
                        camsData.origFile   = filename;
                        camsData.chNameChar = dataIn.chNameComprChar;
                        camsData.chNameNr   = dataIn.chNameComprNr;
                        camsData.date       = dataIn.date;
                        camsData.hour       = dataIn.hour;
                        camsData.chType     = dataIn.chType;
                        camsData.chNo       = dataIn.chNo;
                        camsData.activity   = dataIn.activity;

                        % finally write
                        save(filename_out_mat1, 'camsData')

                end            
            else
                % If only MAT-file is wanted to be save of the input file without
                % further optimization
                if saveAsMAT == 1                    
                    save(filename_out_mat2, 'dataIn')                
                end        
            end
            
    else        
        
        % do something for the reading part
        load(filename_out_mat2)   
        
            if 1 == 2
                load(filename_out_mat1)
                dataIn = camsData;    
                % do something for dataIn.chName
            end
            
    end

        
        
    
    %% FINALLY you split the activity column vector to each individual rows
    % to make it more compatible with other format used by actiBox,
    % NOTE that this will increase the requirement for disk space and you
    % could also save the imported dataIn now and handle the splitting
    % programmatically reducing disk space requirement
    
        % interpolated time
        t_i        = linspace(1,lengthOfOutput,lengthOfOutput*60)';

        % time
        minutes        = (1:1:60)';
        minutesRep     = repmat(minutes, lengthOfOutput, 1);
        secZero        = zeros(length(minutesRep),1);    
        hours          = interp1(double(dataIn.hour(1:lengthOfOutput)), t_i, 'nearest');

        % year, month, day interpoalted separately
        date_i(:,1) = interp1(double(dataIn.date(1:lengthOfOutput,1)), t_i, 'nearest');    
        date_i(:,2) = interp1(double(dataIn.date(1:lengthOfOutput,2)), t_i, 'nearest');    
        date_i(:,3) = interp1(double(dataIn.date(1:lengthOfOutput,3)), t_i, 'nearest');    

        dateFull_vec   = [date_i hours minutesRep secZero]; % date as a vector
        dateFull_num   = datenum(dateFull_vec); % date as a serial number
        dataOut.param.activity_temporalResolution = etime(dateFull_vec(2,:), dateFull_vec(1,:));

        % output variables
        dataOut.chName = char(interp1(double(dataIn.chName(1:lengthOfOutput)), t_i, 'nearest')); % Channel name
        dataOut.date = dateFull_num;     % Date        
        dataOut.chType = uint8(interp1(double(dataIn.chType(1:lengthOfOutput)), t_i, 'nearest'));  % Channel type
        dataOut.chNo = uint16(interp1(double(dataIn.chNo(1:lengthOfOutput)), t_i, 'nearest'));     % Channel number    
        dataOut.activity = reshape(dataIn.activity(1:lengthOfOutput,:)', length(minutesRep), 1);         

    % get back to iriginal working directory
    cd(currDir)
    
    % Debug
    % If you wnat to reduce the size of the dataOut .MAT-file to best way
    % is to do something for the date vector which is at the moment in
    % double precision
    %{
    dataIn        
    dataOut        
    whos
    %}