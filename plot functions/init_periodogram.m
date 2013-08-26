%% SUBFUNCTIONS    
function handles = init_periodogram(handles, param_imp)        

    % init the figure
    handles.figHandles.fft_fig = figure('Name', 'Periodogram Plot', 'Color', 'w');
        % set(handles.figHandles.fft_fig, 'Position', [0.005*handles.scrsz(3) 0.52*handles.scrsz(4) 0.37*handles.scrsz(3) 0.37*handles.scrsz(4)])        
        set(handles.figHandles.fft_fig, 'Position', [0.005*handles.scrsz(3) 0.2*handles.scrsz(4) 0.78*handles.scrsz(3) 0.78*handles.scrsz(4)])        

    % define the number of rows and cols
    spRows = 2; spCols = 2;

    handles.figHandles.fft = zeros(spRows*spCols, 4);

    % Periodogram
    j = 1;
    handles.figHandles.fft_sp(j) = subplot(spRows, spCols, j);          
        hold on
        handles.figHandles.fft(j,1) = bar(NaN, NaN); % fast Lomb           
        handles.figHandles.fft(j,2) = bar(NaN, NaN); % exact Lomb
        handles.figHandles.fft(j,3) = bar(NaN, NaN); % LSPR        
        hold off

        set(handles.figHandles.fft(j,1), 'FaceColor', handles.plotSettings.colorBlack, 'EdgeColor', 'none');
        set(handles.figHandles.fft(j,2), 'FaceColor', handles.plotSettings.colorBlueLight, 'EdgeColor', 'none');
        set(handles.figHandles.fft(j,3), 'FaceColor', handles.plotSettings.colorGreenLight, 'EdgeColor', 'none');

        handles.figHandles.fft_tit(j) = title('');
        handles.figHandles.fft_xlab(j) = xlabel('Period [h]');
        handles.figHandles.fft_ylab(j) = ylabel('Power');

        figHandles.fft_leg = legend('Fast', 'Exact', 2);
            legend('boxoff')
        

    % xxx
    j = 2;
    handles.figHandles.fft_sp(j) = subplot(spRows, spCols, j);           
        handles.figHandles.fft(j,1) = plot(NaN, NaN);
        set(handles.figHandles.fft(j,1), 'Color', handles.plotSettings.colorBlueLight);
        handles.figHandles.fft_tit(j) = title('');
        handles.figHandles.fft_xlab(j) = xlabel('Period [h]');
        handles.figHandles.fft_ylab(j) = ylabel('Amplitude');

    % xxx
    j = 3;
    handles.figHandles.fft_sp(j) = subplot(spRows, spCols, j);
        handles.figHandles.fft(j,1) = bar(NaN, NaN); 
        handles.figHandles.fft_tit(j) = title('');
        handles.figHandles.fft_xlab(j) = xlabel('');
        handles.figHandles.fft_ylab(j) = ylabel('');

    % xxx
    j = 4;
    handles.figHandles.fft_sp(j) = subplot(spRows, spCols, j);
        handles.figHandles.fft(j,1:3) = plot(NaN, NaN, 'r', NaN, NaN, 'k', NaN, NaN, 'b');
        handles.figHandles.fft_tit(j) = title('Detrended/smoothed vs. original (red)');
        handles.figHandles.fft_xlab(j) = xlabel('Time [months]');
        handles.figHandles.fft_ylab(j) = ylabel('Activity');

        set(handles.figHandles.fft(j,3), 'LineWidth', 2, 'Color', handles.plotSettings.colorBlueLight)

    set([handles.figHandles.fft_tit handles.figHandles.fft_xlab handles.figHandles.fft_ylab figHandles.fft_leg],...
        'FontName', handles.plotSettings.fontName, 'FontSize', handles.plotSettings.fontSize_base)
