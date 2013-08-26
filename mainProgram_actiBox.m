%% MAIN PROGRAM
% Call this from the command line or GUI 

function mainProgram_actiBox(style, handles)

    % nicely packed group of subfunction calls for easy change to GUI
    % environment instead of this "command line" use 
    
    for i = 1 : 1 % for importing multiple files at the same time you add a for loop here at some point        

        cd(handles.path.subfunctions) % change current working directory

        %% Import the data using a subfunction
        [data_imp, handles] = import_dataFromFile(handles);
        
        %% Score Sleep/Wake
        [data_imp, handles] = compute_sleepScoring(handles, data_imp);        

        %% Group the data
        [data_group, data_imp, handles] = group_importedData(data_imp, handles);
        
            % Quick and dirty fix, get rid of the first day
            trimToTheseDays = 30;
            for i = 2 : trimToTheseDays
                temp{i-1} = data_group{i};
            end
            data_group = temp;
            data_imp.param.numberOfDays = trimToTheseDays-1;

        %% Computations 
        
            % define the sampling frequency
            data_comp.stats.param_Fs = 1 / data_imp.param.activity_temporalResolution;            
        
            %% FOR ALL THE DATA
            
                %% compute the periodogram

                    if handles.plotON_periodogram ~= 1
                       % if no FFT is plotted there is point to do the exact Lomb 
                       handles.compSet.lomb.exactImplem = 0;
                    end                        

                    [data_comp.all.periodg_x, data_comp.all.periodg_Pxx, data_comp.activity_prePr, stats] = ...
                        compute_periodogram(double(data_imp.activity), data_comp.stats.param_Fs, data_imp.param.timeVectorSeconds, handles);

                    % assign outputs to other variables
                    data_comp.timing            = stats.timing;
                    data_comp.all.periodg_alpha = stats.alpha;                        

                %% compute the DFA

                    if handles.plotON_DFA == 1
                        tic;
                        cd(handles.path.subfunctions_3rd)       
                        
                            try
                                % use the 3rd party implementation, http://www.eng.ox.ac.uk/samp/dfa_soft.html
                                [data_comp.dfa.alpha, data_comp.dfa.intervals, data_comp.dfa.flucts] =...
                                                fastdfa(double(data_imp.activity)); %, handles.compSet.dfa_dfaBins);      
                            catch err
                                err
                            end
                        cd(handles.path.subfunctions)
                        data_comp.timing.dfa = toc;
                    end
                    
            %% FOR DAY-by-DAY DATA
            
                % go through the data by day
                onsetOffset = cell(data_imp.param.numberOfDays,1); cosOut = cell(data_imp.param.numberOfDays,1);

                
                for j = 1 : data_imp.param.numberOfDays                    
                    
                    % Calculate the onset and offset per day
                    if handles.compSet.calculate_onsetOffsets == 1 
                        % correct
                        % Attempt to reference field of non-structure array.
                        % Error in mainProgram_actiBox (line 66)
                        % [onsetOffset{j}, cosOut{j}] = compute_onsetOffsets(data_group{j}.timeInSecond, data_group{j}.activity, handles);
                        onsetOffset{j} = NaN; 
                        cosOut{j}      = NaN;
                    else
                        onsetOffset{j} = NaN; 
                        cosOut{j}      = NaN;
                    end
                    
                end          
                data_comp.onsetOffset = onsetOffset; data_comp.cosOut = cosOut;
                

        %% plot the data
        cd(handles.path.plotFunctions)
        
            % The PLOT of Basic actogram as days as rows 
            if handles.plotON_actogram == 1
                cd(handles.path.plotFunctions)
                plot_actogram2D(data_comp, data_group, data_imp, style, handles)
            end       
            
            % comparison of the sleep stages
            if handles.plotON_sleepScores == 1
                cd(handles.path.plotFunctions)
                plot_sleepScoring(data_group, data_imp, style, handles)
            end

            % The PLOT of FFT
            if handles.plotON_periodogram == 1
                cd(handles.path.plotFunctions)
                plot_periodogram(data_comp, data_group, data_imp, style, handles)
            end

            % The PLOT of DFA
            if handles.plotON_DFA == 1
                cd(handles.path.plotFunctions)
                plot_DFA(data_comp, style, handles)        
            end

            % Bout analysis
            if handles.plotON_boutAnalysis == 1
                cd(handles.path.plotFunctions)
                [dataBouts, handles] = plot_boutAnalysis(data_comp, data_group, data_imp, style, handles);
            end        
        
        cd(handles.path.subfunctions)

        
        %% log the data to a disk
        handles = log_theDataToDisk(data_group, data_imp, handles);           

        
    end
    cd(handles.path.mainCode) % change current working directory
    data_comp.timing 
