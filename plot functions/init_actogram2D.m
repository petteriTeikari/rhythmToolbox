%% SUBFUNCTIONS    
function handles = init_actogram2D(handles, param_imp)        

    % init the figure
    handles.figHandles.actogram_fig = figure('Name', 'Actogram', 'Color', 'w');
        set(handles.figHandles.actogram_fig, 'Position', [0.6*handles.scrsz(3) 0.05*handles.scrsz(4) 0.38*handles.scrsz(3) 0.85*handles.scrsz(4)])        

    % se the y-axis limits of the figure to 0 and 1 and then you later scale your actual date
    % corresponding to the amount of days and actual y-limits per day
    yLimits = [0 1];        

    % define the number of rows in the plot
    spRows   = (param_imp.numberOfDays); 

    % define the y-scaling again for the baselines
    yOffset    = 0.00; 
    yInterv    = (yLimits(2) - yLimits(1)) / spRows;        
    safeLim    = 0.05; % [relative, ~%] avoid bars touching previous days in y-direction
    yLimOrig   = handles.plotSettings.activity_YLimits;
    yScaler    = (yInterv * (1-safeLim)) / yLimOrig(2); % scalar defining the ratio between original and scaled y

    % preallocate memory
    h_sLog = zeros(spRows,1); h_acti = h_sLog; h_sAut = h_sLog; h_cosi = h_sLog;      
    y_scaledLimits = zeros(spRows,1); 

    hold on
    for i = 1 : spRows            

        % sleep log (if any, add a condition)
        h_sLog(i) = bar(NaN, NaN);            

        % area for actogram (hist could be added as an alternative)
        h_acti(i) = bar(NaN, NaN);

        % area for actogram (hist could be added as an alternative)
        h_cosi(i) = plot(NaN, NaN);

        % automated sleep (if any, add a condition)
        h_sAut(i) = bar(NaN, NaN);

        y_baseline            = yLimits(2) - yOffset - ((i-0) * yInterv);
        y_scaledLimits(i,1:2) = [y_baseline (y_baseline + (yInterv * (1-safeLim)))];
        handles.figHandles.actogram_ylab(i) = text(handles.plotSettings.timeLimits(1), mean(1/yScaler * y_scaledLimits(i,1:2)), ' ');

    end

    % scale the relative values to absolute values
    y_scaledLimits  = 1/yScaler * y_scaledLimits;
    yLimits         = 1/yScaler * yLimits;
    ylim(yLimits) 

    % assign to the output structure "handles"
    handles.plotSettings.actog_y_scaledLimits = y_scaledLimits;
    handles.plotSettings.actog_yScaler        = yScaler;

    % assing to the actual variable name
    handles.figHandles.actogram.h_acti   = h_acti;
    handles.figHandles.actogram.h_sAut   = h_sAut;
    handles.figHandles.actogram.h_sLog   = h_sLog;
    handles.figHandles.actogram.h_cosi   = h_cosi;

    % style the plot now
    handles.figHandles.actogram = style_actogramAxes(handles, handles.figHandles.actogram);
    hold off



function H_act = style_actogramAxes(handles, H_act)         

    box on        

    % display nicely with minimal borders
    offs_x = 0.03; offs_y = 0.03;
    set(gca,'pos', [0+offs_x 0+offs_y 1-(2*offs_x) 1-(2*offs_y)]); 

    set(gca, 'FontName', handles.plotSettings.fontName)
    set(gca, 'FontSize', handles.plotSettings.fontSize_base)
    set(handles.figHandles.actogram_ylab, 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base - 1)

    set(gca, 'YTick', [])
    % set(gca, 'YLim', handles.plotSettings.activity_YLimits); 

    % define XTick locations
    XTickInterv = (handles.plotSettings.timeLimits(2) - handles.plotSettings.timeLimits(1)) / (length(handles.plotSettings.timeVector) - 1);
    XTickLims = (handles.plotSettings.timeLimits(1):XTickInterv:handles.plotSettings.timeLimits(2))';

        %% does not work for some reason ? :o (PT)            

    set(gca, 'XTick',       XTickLims)                
    set(gca, 'XTickLabel',  num2str(handles.plotSettings.timeVector))  
    set(gca, 'XLim',        [XTickLims(1) XTickLims(end)])                                          
    % datetick(gca, 'x', 15)    

    % set the default colors        
    set(H_act.h_acti, 'FaceColor', handles.plotSettings.colorBlueDark, 'EdgeColor', 'none')
    set(H_act.h_sAut, 'FaceColor', handles.plotSettings.colorOrange,    'EdgeColor', 'none')         
    set(H_act.h_sLog, 'FaceColor', handles.plotSettings.colorGrayLight, 'EdgeColor', 'none')
    set(H_act.h_cosi, 'Color', handles.plotSettings.colorGreenLight, 'LineStyle', '--')

    % add the grid to the figure
        % use gridxy

    % define the order of the elements (i.e. which is top of which)
    uistack(H_act.h_sAut, 'bottom');
    uistack(H_act.h_sLog, 'bottom');

    H_act.titleHandle = title(handles.fileNameWoExt);
        set(H_act.titleHandle, 'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base)
        set(H_act.titleHandle, 'interpreter', 'none')
