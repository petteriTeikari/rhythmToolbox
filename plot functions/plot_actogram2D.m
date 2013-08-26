function plot_actogram2D(data_comp, data_group, data_imp, style, handles)
        
    % Init the figure    
    handles = init_actogram2D(handles, data_imp.param);            
    
    % Update the figure
    handles = update_actogram2D(data_comp, data_group, data_imp, handles);    
    
    % autosave the figure      
    if style.imgOutautoSavePlot == 1            
        fileNameOut = ['actogramPlot_', strrep(handles.importSettings.inputFile, '.txt', ''), '.png'];
        cd(handles.path.figuresOut)
        saveToDisk(handles.figHandles.actogram_fig, fullfile(handles.path.figuresOut, fileNameOut), style)
        % cd(handles.path.mainCode)
    end