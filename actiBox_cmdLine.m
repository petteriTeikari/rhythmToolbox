function actiBox_cmdLine()

    % Petteri Teikari, petteri.teikari@gmail.com / inserm.fr, 2011
    % Command-line version            

    %% GENERAL SETTINGS
    handles.scrsz = get(0,'ScreenSize'); % get screen size for plotting
    close all % close all open figures
    
        % use subfunction to set the default settings
        [handles, style] = setDefaultSettings(handles);     
        
        
    
    %% Call for the MAIN PROGRAM
           
        % handles.importSettings.inputFile  = 'nickie_tot_downs2.txt';
        % handles.importSettings.inputFile  = 'Nickie_Tot.TXT';
        % handles.importSettings.inputFile  = 'flyEx_valeria_avActiv_interp.txt';
        handles.importSettings.inputFile  = 'Petteri Activity curve 2011-03-02 - 2011-04-06.txt';
        % handles.importSettings.inputFile  = 'Nickie1.dat';
        % handles.importSettings.inputFile    = 'B00011_2009-06-10_14-20-00.daq';
        
        handles.importSettings.inputFolder  = handles.path.dataTesting;
        handles.importSettings.downSampleBy = 1; % for testing purposes to speed up the computation

        % call the main program
        mainProgram_actiBox(style, handles)           
        
        
    