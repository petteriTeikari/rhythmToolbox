function plot_DFA(data_comp, style, handles)
    
    % Init the figure
    handles = init_DFA(handles, data_comp.dfa);
    
    % Update the plot
    handles = update_DFA(data_comp, handles);
        
    % autosave the figure      
    if style.imgOutautoSavePlot == 1            
        fileNameOut = ['dfaAnalysis_', strrep(handles.importSettings.inputFile, '.txt', ''), '.png'];
        cd(handles.path.figuresOut)
        saveToDisk(handles.figHandles.dfa_fig, fullfile(handles.path.figuresOut, fileNameOut), style)
        % cd(handles.path.mainCode)
    end