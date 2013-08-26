function dataOut = import_actim_generic(filename, handles)

    currDir = pwd;
    cd(handles.importSettings.inputFolder)
    impTemp = importdata(filename, handles.importSettings.activFileParam.delimiter, handles.importSettings.activFileParam.headerRows);
    cd(currDir)
            
    if handles.importSettings.activFileParam.headerRows == 0
        timeRaw = impTemp(:,1);
        dataOut.activity = impTemp(:,2);        
    else
        timeRaw = impTemp.data(:,1);
        dataOut.activity = impTemp.data(:,2);        
        dataOut.headers  = impTemp.textdata;
    end
    
    % Now the time should be imported correctly?
    % automagization?, manual at the moment    
    firstTimeValue = timeRaw(1);
    
        % crappy condition
        if firstTimeValue < 10^5
        
            % if the time is in seconds          
            [h,m,s] = sec2hms(timeRaw);
            days = floor(hms2days(h,m,s));

            % fix the hours
            h = rem(h,24);        
            ONE = ones(length(h), 1);          
            dateVector = [ONE ONE days h m s];
            dataOut.date  = datenum(dateVector);        
            dataOut.param.activity_temporalResolution = 60*30; % [s]                        
        
        else
            
            % if the the time is as serial number
            dataOut.date = timeRaw;
            dataOut.param.activity_temporalResolution = etime(datevec(timeRaw(2)), datevec(timeRaw(1)));
            dataOut.param.activity_temporalResolution = 60;           
        end                
        
        if handles.importSettings.downSampleBy ~= 1
            dataOut.date     = (linspace(min(dataOut.date), max(dataOut.date), length(dataOut.date)/handles.importSettings.downSampleBy))';
            dataOut.activity = interpft(dataOut.activity, length(dataOut.date)); %% FFT Interpolation
            dataOut.param.activity_temporalResolution = dataOut.param.activity_temporalResolution * handles.importSettings.downSampleBy;
        end
        
        function [hour, minute, second] = sec2hms(sec)
        %SEC2HMS  Convert seconds to hours, minutes and seconds.
        %
        %   [HOUR, MINUTE, SECOND] = SEC2HMS(SEC) converts the number of seconds in
        %   SEC into hours, minutes and seconds.

        %   Author:      Peter John Acklam
        %   Time-stamp:  2002-03-03 12:50:09 +0100
        %   E-mail:      pjacklam@online.no
        %   URL:         http://home.online.no/~pjacklam

           hour   = fix(sec/3600);      % get number of hours
           sec    = sec - 3600*hour;    % remove the hours
           minute = fix(sec/60);        % get number of minutes
           sec    = sec - 60*minute;    % remove the minutes
           second = sec;
           
        function days = hms2days(varargin)
        %HMS2DAYS Convert hours, minutes, and seconds to days.
        %
        %   DAYS = HMS2DAYS(HOUR, MINUTE, SECOND) converts the number of hours,
        %   minutes, and seconds to a number of days.
        %
        %   The following holds (to within rounding precision):
        %
        %     DAYS = HOUR / 24 + MINUTE / (24 * 60) + SECOND / (24 * 60 * 60)
        %          = (HOUR + (MINUTE + SECOND / 60) / 60) / 24

        %   Author:      Peter John Acklam
        %   Time-stamp:  2004-09-22 08:45:33 +0200
        %   E-mail:      pjacklam@online.no
        %   URL:         http://home.online.no/~pjacklam

           nargsin = nargin;
           error(nargchk(1, 3, nargsin));
           argv = {0 0 0};
           argv(1:nargsin) = varargin;
           [hour, minute, second] = deal(argv{:});

           days = (hour + (minute + second / 60) / 60) / 24;

