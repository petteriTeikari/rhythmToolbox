function handles = update_actogram2D(data_comp, data_group, data_imp, handles)
    
    %{
    % areas for automated sleep detection and for sleep log sleep time
        fullAreaTemp = handles.plotSettings.activity_YLimits(2) * ones(length(data_group{i}.timeOnly),1);
            sleepAutom = fullAreaTemp; sleepAutom(data_group{i}.sleep == 0) = 0;
            sleepAutom = handles.plotSettings.sleepAutom_scalar * sleepAutom;

            sleepLog = fullAreaTemp; sleepLog(data_group{i}.sleepLog == 0) = 0;
            sleepLog = handles.plotSettings.sleepLog_scalar * sleepLog;
    %}

    %% go through the data and change to next subplot when the day
    % changes (or after ZT24 or CT24 or as you wish)    

    % reassign the handle variables
    h_acti = handles.figHandles.actogram.h_acti;
    h_sLog = handles.figHandles.actogram.h_sLog;
    h_sAut = handles.figHandles.actogram.h_sAut;
    h_cosi = handles.figHandles.actogram.h_cosi;

    for i = 2 : data_imp.param.numberOfDays

        % use shorter and more intuitive variable name for the dynamic baseline
        y_baseline = handles.plotSettings.actog_y_scaledLimits(i,1);  

        if strcmp(handles.importSettings.importFrom, 'Generic_TimeActivity') ~= 1
            % areas for automated sleep detection and for sleep log sleep time
            fullAreaTemp = handles.plotSettings.activity_YLimits(2) * ones(length(data_group{i}.timeOnly),1);
                sleepAutom = fullAreaTemp; sleepAutom(data_group{i}.sleep == 0) = 0;
                sleepAutom = handles.plotSettings.sleepAutom_scalar * sleepAutom;

                sleepLog = fullAreaTemp; sleepLog(data_group{i}.sleepLog == 0) = 0;
                sleepLog = handles.plotSettings.sleepLog_scalar * sleepLog;
        end

        % update the activity
        set(h_acti(i), 'XData', data_group{i}.timeOnly, 'YData', data_group{i}.activity+y_baseline)        

            % update the baseline value accordingly         
            set(h_acti(i), 'BaseValue', y_baseline, 'ShowBaseLine', 'on')

        % update the cosinor
            if handles.compSet.calculate_onsetOffsets == 1
                set(h_cosi(i), 'XData', data_group{i}.timeOnly, 'YData', data_comp.cosOut{i}.fit+y_baseline)        

                    % mark the peak with red circle
                    % [maxV,xInd] = max(data_comp.cosOut{i}.fit); plot(xInd, maxV, 'ro')
            end

        if strcmp(handles.importSettings.importFrom, 'Generic_TimeActivity') ~= 1

            % update the sleep log   
            set(h_sLog(i), 'XData', data_group{i}.timeOnly, 'YData', sleepLog+y_baseline)  

                % update the baseline value accordingly         
                set(h_acti(i), 'BaseValue', y_baseline, 'ShowBaseLine', 'on')

            % update the automated sleep detection           
            set(h_sAut(i), 'XData', data_group{i}.timeOnly, 'YData', sleepAutom+y_baseline);                

                % update the baseline value accordingly         
                set(h_acti(i), 'BaseValue', y_baseline, 'ShowBaseLine', 'on')
        end

        % Add the ylabel
        set(handles.figHandles.actogram_ylab(i), 'String', ['Day ', num2str(i)])

        drawnow 

    end            




