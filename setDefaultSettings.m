%% SETTINGS
function [handles, style] = setDefaultSettings(handles)

    %% set the paths to be used        
    handles.path.mainCode   = mfilename('fullpath'); % Setting the path for the code    
    handles.path.mainCode   = strrep(handles.path.mainCode, 'setDefaultSettings', ''); % Removing the filename from the path

    handles.path.subfunctions       = fullfile(handles.path.mainCode, 'subfunctions');        
        handles.path.fitFunctions   = fullfile(handles.path.subfunctions, 'fitFunctions');  
        handles.path.sleepScoring   = fullfile(handles.path.subfunctions, 'sleepScoring');       
    handles.path.subfunctions_3rd   = fullfile(handles.path.mainCode, 'subfunctions (3rd party)');  
        handles.path.LSPR           = fullfile(handles.path.subfunctions_3rd, 'LSPR');  
    handles.path.plotFunctions      = fullfile(handles.path.mainCode, 'plot functions');        

    handles.path.data = fullfile(handles.path.mainCode, 'data');           

        % optional user-specific data folders
        handles.path.dataVivago     = fullfile(handles.path.data, 'Vivago');   
        handles.path.dataTesting    = fullfile(handles.path.data);   
        handles.path.dataSleepLogs  = fullfile(handles.path.data, 'Sleep Logs');   
        handles.path.dataFly        = fullfile(handles.path.data, 'Fly');   
        handles.path.dataMonkey     = fullfile(handles.path.data, 'Monkey');   
        handles.path.figuresOut     = fullfile(handles.path.data, 'figures');     

    %% import settings
    handles.importSettings.importFilesOrFolder  = 'file';        
    handles.importSettings.initFolder           = handles.path.dataVivago;
    handles.importSettings.importFrom           = 'Vivago';
    handles.importSettings.rejectOutliers       = 1;
    handles.importSettings.importSleepLog       = 1;        
    handles.importSettings.SleepLogFormat       = 'petteri';          
    handles.importSettings.import_fileFormat  = 'txt'; % or .mat for pre-imported files
    % handles.importSettings.import_fileFormat    = 'mat'; % or .txt for raw files


    %% Computation settings

    % sleep score
    handles.compSet.scoreSleep_ON           = 1;        
    handles.compSet.scoreSleep_Sadeh        = 1;
        handles.compSet.scoreSleep_Sadeh_epochCriterion = [50 100] / ((2^8)-1);
        handles.compSet.scoreSleep_Sadeh_PSthreshold    = 0.1;
    handles.compSet.scoreSleep_JeanLouis    = 1;
        handles.compSet.scoreSleep_JeanLouis_scaler = 0.05;
    handles.compSet.scoreSleep_Sazonov      = 1;
    handles.compSet.scoreSleep_Scripps      = 1;
        handles.compSet.scoreSleep_Scripps_scaler       = 0.30;
        handles.compSet.scoreSleep_Scripps_postScoreThr = 10; % number of epochs

    % periodogram
    handles.compSet.fftPeriodg.window   = [];
    handles.compSet.fftPeriodg.nfft     = [];
    handles.compSet.lomb.fastImplem     = 1;
    handles.compSet.lomb.exactImplem    = 1;

    handles.compSet.prunePeriods_pThreshold = 1 ;
    handles.compSet.lomb.pThreshold         = 0.0001;

    % LSPR
    handles.compSet.LSPR.calculateLSPR          = 0;
    handles.compSet.LSPR.defPeriod              = 24 * 60 * 60; % h * m * s, -> [s]
    handles.compSet.LSPR.periodLower            = 2 * 60 * 60; % h * m * s, -> [s]
    handles.compSet.LSPR.periodUpper            = 28 * 60 * 60; % h * m * s, -> [s]
    handles.comptSet.LPRS_periodRes_xMinutes    = 4;
    handles.compSet.LSPR.lombToUse      = 'orig';
    % handles.compSet.LSPR.lombToUse      = 'exact';
    % handles.compSet.LSPR.lombToUse      = 'fast';            

    % ONSER/OFFSET -detection
        handles.compSet.calculate_onsetOffsets = 0; % not working atm

        % Threshold detector
        handles.compSet.onsetThreshold  = 8 / 74;

        % Cosine fit parameters

            % default INIT VALUES for the optimization process
            handles.compSet.cosineFit.init.b = 1;   % baseline level
            handles.compSet.cosineFit.init.H = 50;  % height (i.e., peak level)
            handles.compSet.cosineFit.init.v = 0.3; % skewness
            handles.compSet.cosineFit.init.c = 0.2; % width 
            handles.compSet.cosineFit.init.f = 0.6; % phi, the phase in radians
            handles.compSet.cosineFit.init.m = 0.3; % bimodality parameter

            % BOUNDS for the optimization [lowerBound upperBound]
            handles.compSet.cosineFit.bounds.b = [0 Inf];   % baseline level
            handles.compSet.cosineFit.bounds.H = [0 Inf];   % height (i.e., peak level)
            handles.compSet.cosineFit.bounds.v = [-1 1];    % skewness
            handles.compSet.cosineFit.bounds.c = [-1 1];    % width 
            handles.compSet.cosineFit.bounds.f = [0 Inf];   % phi, the phase in radians
            handles.compSet.cosineFit.bounds.m = [0 1];     % bimodality parameter            

    % DFA
    handles.compSet.dfa_binInterval     = 1; % [minutes]
    handles.compSet.dfa_dfaBins         = (logspace(0,8,27))'; % in hours
    handles.compSet.dfa_offset          = 0; % for plotting
    handles.compSet.dfa_fitOffsetIndex  = 4; % choose of what data point has to be crossed for linear regression


%% plot settings                            
    handles.plotON_actogram     = 1;
    handles.plotON_periodogram  = 1;
    handles.plotON_sleepScores  = 1; 
    handles.plotON_DFA          = 1;
    handles.plotON_boutAnalysis = 1;        
    
    % FIGURE autosave options
    style.imgOutRes       = '-r300'; % dpi
    style.imgOutAntiAlias = '-a2';   % '-a0' least, '-a4' maximum
    style.imgOutautoSavePlot = 1;    

    handles.plotSettings.fontName           = 'Latin Modern Roman';
    handles.plotSettings.fontSize_base      = 8;
    handles.plotSettings.hourLimits         = [0 24];
    handles.plotSettings.activity_YLimits   = [0 2^7]; % is overrid automatigally per file
    handles.plotSettings.timDiv             = 2;
    handles.plotSettings.timeVector         = (0:handles.plotSettings.timDiv:24)';
    handles.plotSettings.fft_freqLimits     = [10^-6 10^-4];
    handles.plotSettings.fft_timeLimits     = 1 ./ handles.plotSettings.fft_freqLimits;      
    handles.plotSettings.fft_PeriodLimits   = [0 28];

    handles.plotSettings.sleepAutom_scalar  = 0.08;
    handles.plotSettings.sleepLog_scalar    = 0.92;

    handles.plotSettings.actoDoublePlot = 0; % whether you plot two days on same row or just one, NOT IMPLEMENTED YET

    timeLimits                      = [1 1 1 0 0 0; 1 1 1 24 0 0]; % yy mm dd hh mm ss, start - END
    handles.plotSettings.timeLimits = datenum(timeLimits); % one day as serial number


        % Reduced palette allowing "Color Scheme" in Powerpoint
        % type of manipulation of the colors
        handles.plotSettings.colorBlueLight  = [0.043 0.518 0.780];
        handles.plotSettings.colorBlueDark   = [0.012 0.153 0.231];
        handles.plotSettings.colorRedLight   = [0 0 0];
        handles.plotSettings.colorRedDark    = [1 0 0];
        handles.plotSettings.colorGreenLight = [0 1 0];
        handles.plotSettings.colorGreenDark  = [0 0 0];
        handles.plotSettings.colorOrange     = [1.000 0.400 0.000];
        handles.plotSettings.colorYellow     = [1.000 0.400 0.000];
        handles.plotSettings.colorGrayLight  = [0.880 0.890 0.885];
        handles.plotSettings.colorGrayDark   = [0.400 0.400 0.400];
        handles.plotSettings.colorBlack      = [0.000 0.000 0.000];
        handles.plotSettings.colorWhite      = [1.000 1.000 1.000];
        handles.plotSettings.colorCustom1    = [0 0 0];
        handles.plotSettings.colorCustom2    = [0 0 0];
        handles.plotSettings.colorCustom3    = [0 0 0];


% init text
cl = fix(clock); hours = num2str(cl(4)); % get the current time
if cl(5) < 10; mins = ['0', num2str(cl(5))]; else mins = num2str(cl(5)); end
        disp(' '); 
        disp('           | | (_)  _ \            ')
        disp('  __ _  ___| |_ _| |_) | _____  __ ')
        disp(' / _` |/ __| __| |  _ < / _ \ \/ / ')
        disp('| (_| | (__| |_| | |_) | (_) >  <  ')
        disp(' \__,_|\___|\__|_|____/ \___/_/\_\ ')
        disp(' \__,_|\___|\__|_|____/ \___/_/\_\ ')
        disp('    petteri.teikari@gmail.com, 2011');
        disp('    INSERM U846, Dept.Chronobiology');
        disp('                       Lyon, France');
        disp(' ');    
        disp(['  Initiated: ', date, ', ', hours, ':', mins])
        disp('  ----'); disp(' '); 
