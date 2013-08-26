function plot_sleepScoring(data_group, data_imp, style, handles)

    rows = 7; cols = 1;
    fig = figure('Color', 'w');
    
        set(fig, 'Position', [0.6*handles.scrsz(3) 0.05*handles.scrsz(4) 0.38*handles.scrsz(3) 0.85*handles.scrsz(4)]) 
    
        i = 1;
        sp(i) = subplot(rows,cols,i);
            a(i) = area(data_imp.date, data_imp.activity);
            xlim([min(data_imp.date) max(data_imp.date)])        
            tit(i) = title('Activity');
            datetick('x',19)
        
        i = 2;
        sp(i) = subplot(rows,cols,i);       
            a(i) = area(data_imp.date, data_imp.sleepLog.booleanVector); 
            xlim([min(data_imp.date) max(data_imp.date)])
            ylim([0 1.1]); tit(i) = title('Sleep Log');
            datetick('x',19)
        
        i = 3;
        sp(i) = subplot(rows,cols,i);     
            a(i) = area(data_imp.date, data_imp.sleep); 
            xlim([min(data_imp.date) max(data_imp.date)])
            ylim([0 1.1]); tit(i) = title('Vivago Scoring');
            datetick('x',19)
            
        i = 4;
        sp(i) = subplot(rows,cols,i);
            a(i) = area(data_imp.date, data_imp.sleep_sadeh1994.sleepBoolean); 
            xlim([min(data_imp.date) max(data_imp.date)])
            ylim([0 1.1]); tit(i) = title('Sadeh et al. 1994');
            datetick('x',19)

        i = 5;
        sp(i) = subplot(rows,cols,i);
            a(i) = area(data_imp.date, data_imp.sleep_jeanLouis2001.sleepBoolean);
            xlim([min(data_imp.date) max(data_imp.date)])
            ylim([0 1.1]); tit(i) = title('Jean-Louis et al. 2001');
            datetick('x',19)
              
        i = 6;
        sp(i) = subplot(rows,cols,i);
            a(i) = area(data_imp.date, data_imp.sleep_scripps2010.sleepBoolean);
            xlim([min(data_imp.date) max(data_imp.date)])
            ylim([0 1.1]); tit(i) = title('Scripps 2010 (Kripke et al.)');
            datetick('x',19)

        i = 7;
        sp(i) = subplot(rows,cols,i);
            a(i) = area(data_imp.date, data_imp.sleep_scripps2010.sleepBoolean_w_postScoring);
            xlim([min(data_imp.date) max(data_imp.date)])
            ylim([0 1.1]); tit(i) = title('Scripps 2010 (Kripke et al.) w post-scoring');
            ylab = ylabel('Days');
            datetick('x',19)
         
        set(a, 'FaceColor', [0 0.3 1], 'EdgeColor', 'none')
        set(sp, 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base-1)
        set(tit, 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base, 'FontWeight', 'bold')
        set(ylab, 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base-1)
        
        
        
    % autosave the figure      
    if style.imgOutautoSavePlot == 1            
        fileNameOut = ['dfaAnalysis_', strrep(handles.importSettings.inputFile, '.txt', ''), '.png'];
        cd(handles.path.figuresOut)
        saveToDisk(fig, fullfile(handles.path.figuresOut, fileNameOut), style)
        % cd(handles.path.mainCode)
    end