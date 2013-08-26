%% Subfunction to initialize the plots
function handles = init_DFA(handles, dfa)
        
    % use shorter variable names
    alpha       = dfa.alpha;
    intervals   = dfa.intervals;
    flucts      = dfa.flucts;        

    % number of subplot rows and cols
    spRows = 2; 
    spCols = 1;

    %% figure
    handles.figHandles.dfa_fig = figure('Name', 'Detrended Fluctuation Analysis (DFA)', 'Color', 'w');
        set(handles.figHandles.dfa_fig, 'Position', [0.005*handles.scrsz(3) 0.06*handles.scrsz(4) 0.37*handles.scrsz(3) 0.37*handles.scrsz(4)])

    %% subplot 1
    handles.figHandles.dfa_sp(1) = subplot(spRows, spCols, 1);    
    handles.figHandles.dfa_p(1:2) = loglog(NaN, NaN, NaN, NaN, 'o');                

        % STYLE
        % -----
            xlim([0 max(intervals)])
            % ylim([0 2 * max(flucts)])

            % X-Axis             
            handles.x_lab = xlabel('Time Scale n(data points)', 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base);            
            set(gca, 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base) 

            % Y-Axis
            handles.y_lab = ylabel('Detrended fluctuation F(n)', 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base);            
            set(gca, 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base) 

            % annotate alpha
            text(max(intervals)/100, max(flucts)/2, ['\alpha = ', num2str(alpha,2)],...
                'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'FontName', handles.plotSettings.fontName, 'FontWeight', 'bold')


    %% subplot 2
    handles.figHandles.dfa_sp(2) = subplot(spRows, spCols, 2);    
    handles.figHandles.dfa_p(3:4) = loglog(NaN, NaN, NaN, NaN, 'o');                   

        % STYLE
        % -----

            set(handles.figHandles.dfa_p([1 3]), 'Color', [0 0.533 0.831], 'LineWidth', 1.5);
            set(handles.figHandles.dfa_p([2 4]), 'MarkerFaceColor', [1 0.4 0], 'MarkerEdgeColor', [0 0 0]);

            fittingOffsetIndex = handles.compSet.dfa_fitOffsetIndex; % choose of what data point has to be crossed for linear regression
            handles.alpha_2 = alpha - 1;
            handles.offset_2 = (flucts(fittingOffsetIndex) ./ intervals(fittingOffsetIndex)) - (intervals(fittingOffsetIndex) .^ handles.alpha_2);           

            xlim([0 max(intervals)])
            % ylim([0 2 * max((flucts ./ intervals))])

            % X-Axis             
            handles.x_lab = xlabel('Time Scale n(data points)', 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base);            
            set(gca, 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base-1)  

            % Y-Axis
            handles.y_lab = ylabel('F(n) / n', 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base);            
            set(gca, 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base) 

            % annotate alpha
            text(max(intervals)/100, max(flucts ./ intervals)/2, ['\alpha" = ', num2str(handles.alpha_2,1)],...
                'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'FontName', handles.plotSettings.fontName, 'FontWeight', 'bold')     

