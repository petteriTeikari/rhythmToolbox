function handles = update_periodogram(handles, data_comp, data_group, data_imp)    
    
    if nargin == 0
        load tempDebug.mat
    else
        save tempDebug.mat
    end

    % Update the graphs

    % subplot 1
        if handles.compSet.lomb.exactImplem == 1                
            xPeriod = (1 ./ data_comp.all.periodg_x.exactlomb) / 60 / 60;
            yNorm = data_comp.all.periodg_Pxx.exactlomb ./ max(data_comp.all.periodg_Pxx.exactlomb);
            set(handles.figHandles.fft(1,1), 'XData', xPeriod, 'YData', yNorm)                
        end

        if handles.compSet.lomb.fastImplem == 1
            xPeriod = (1 ./ data_comp.all.periodg_x.fastlomb) / 60 / 60;            
            yNorm = data_comp.all.periodg_Pxx.fastlomb ./ max(data_comp.all.periodg_Pxx.fastlomb);
            set(handles.figHandles.fft(1,2), 'XData', xPeriod, 'YData', yNorm)                
        end

        if handles.compSet.LSPR.calculateLSPR == 1
            xPeriod = (1 ./ data_comp.all.periodg_x.LSPR) / 60 / 60;                
            set(handles.figHandles.fft(1,3), 'XData', xPeriod, 'YData', data_comp.all.periodg_Pxx.LSPR)                
        end

        
        % legend('exact Lomb', 'fast Lomb', 'LSPR')

        % could write a dynamic scaling of the plot
        set(handles.figHandles.fft_sp(1), 'XLim', handles.plotSettings.fft_PeriodLimits)
        set(handles.figHandles.fft_tit(1), 'String', ['Fast LOMB, n = ', num2str(length(data_comp.all.periodg_Pxx.fastlomb))])


    % subplot 2
        set(handles.figHandles.fft(2,1), 'XData', 1 ./ data_comp.all.periodg_x.fft / 60 / 60, 'YData', data_comp.all.periodg_Pxx.fft)
        set(handles.figHandles.fft_sp(2), 'XLim', handles.plotSettings.fft_PeriodLimits)
        set(handles.figHandles.fft_tit(2), 'String', ['FFT Amplitude Spectrum, nfft = ', num2str(length(data_comp.all.periodg_Pxx.fft))])


    % subplot 3        

        % could write a dynamic scaling of the plot
        % set(handles.figHandles.fft_sp(3))
        set(handles.figHandles.fft_tit(3), 'String', ['LSPR'])
        
        if handles.compSet.LSPR.calculateLSPR == 1
            data_comp.all.periodg_x.LSPR
            xPeriod = (1 ./ data_comp.all.periodg_x.LSPR) / 60 / 60;
            xLSPR = data_comp.all.periodg_Pxx.LSPR
            yLSPR = data_comp.all.periodg_Pxx.LSPR
                % check the data, and what should be plotted (Aug 2013)
            set(handles.figHandles.fft(3,1), 'XData', xPeriod, 'YData', data_comp.all.periodg_Pxx.LSPR)
        end



    % subplot 4
        set(handles.figHandles.fft(4,1), 'XData', data_imp.date, 'YData', data_imp.activity)
        set(handles.figHandles.fft(4,2), 'XData', data_imp.date, 'YData', data_comp.activity_prePr)
        set(handles.figHandles.fft(4,3), 'XData', data_imp.date, 'YData', data_imp.activity-data_comp.activity_prePr)
        set(handles.figHandles.fft_sp(4), 'YLim', ([min(data_comp.activity_prePr) handles.plotSettings.activity_YLimits(2)]))

        datetick('x',5)
        set(handles.figHandles.fft_sp(4), 'XLim', ([min(data_imp.date) max(data_imp.date)]))
