function plot_periodogram(data_comp, data_group, data_imp, style, handles)

    % Init the figure
    handles = init_periodogram(handles, data_imp.param);        
    
    % Update the plot    
    handles = update_periodogram(handles, data_comp, data_group, data_imp);

    % autosave the figure      
    if style.imgOutautoSavePlot == 1            
        fileNameOut = ['periodogram_', strrep(handles.importSettings.inputFile, '.txt', ''), '.png'];
        cd(handles.path.figuresOut)
        saveToDisk(handles.figHandles.fft_fig, fullfile(handles.path.figuresOut, fileNameOut), style)
        % cd(handles.path.mainCode)
    end