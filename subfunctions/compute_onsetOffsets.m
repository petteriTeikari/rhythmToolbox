function [onsetOffset, cosOut] = compute_onsetOffsets(t, y, handles)    

    if nargin == 0
        load cosine_vanSomerenTesting.mat
    else
        save cosine_vanSomerenTesting.mat
    end
    whos

    % save('inputDataForCosineFitting.mat', 't', 'y')
    
    y_in            = y;
    onsetOffset     = [NaN NaN];
    
    period          = 23.98; % in future, read from periodogram
    w               = (1 / (60 * 60 * period)) * 2 * pi(); % angular frequency [rad/s]
    w_24h           = (1 / (60 * 60 * 24.00)) * 2 * pi(); % angular frequency [rad/s]
    alpha           = 0.05; % desired confidence level
    handles.wMax    = (w / w_24h) * 2*pi(); % tau, the intrinsic period, relative to 2*pi()

         
        
        
    %% Static Threshold
        
        % test with a relative fixed threshold that could be later operated
        % by a switch in GUI        
        y_thr = y - (handles.compSet.onsetThreshold * handles.plotSettings.activity_YLimits(2));
        y_thr(y_thr < 0) = 0; % make all negative values zero
        y = y_thr;
        
        y_smoo = smooth(y);      
        
        % scale so that the peak of loess will have xx% of the max of raw data
        scaleScalar = 0.88; 
        y_smoo = ((max(y_in) / max(y_smoo)) * scaleScalar) * y_smoo;            
        y = y_smoo;
    

    %% Cosinor analysis
    %  with a "known" period taken from the periodogram analysis    
    
        cd(handles.path.subfunctions_3rd); tic;
        cosOut = cosinor(t,y,w,alpha);
        
        cd(handles.path.subfunctions); t_cosinor = toc;
        
        % scale the fit also
        cosOut.fit(cosOut.fit < 0) = 0;
        cosOut.fit = ((max(y_in) / max(cosOut.fit)) * scaleScalar) * cosOut.fit;
        
        
        % debug plot
        p(1) = plot(t,y_in); set(p(1), 'Color', [.7 .7 .7])
        xlim([0 86400])  
        hold on; 
        p(2) = plot(t,y_smoo, '--r');
        p(3) = plot(t, cosOut.fit, 'g'); 
        hold off % plot
        %}

        
    
    %% Van Someren and Nagtegaal (2007) functions
    [out, timeExec] = vanSomerenAndNagtegaal2007(t, y, handles)
    
        % update the plot
        %{
        currDir = pwd; cd(handles.path.fitFunctions)
        p(3) = plot(t, fit_cosineBCF(out.BCF.x, out.tRad), '--b'); % plot
        p(4) = plot(t, fit_cosineSBCF(out.SBCF.x, out.tRad), 'g'); % plot
        p(5) = plot(t, fit_cosineBBCF(out.BBCF.x, out.tRad), 'y'); % plot
        p(6) = plot(t, fit_cosineBSBCF(out.BSBCF.x, out.tRad), 'k'); % plot
        cd(currDir)        
        
        legend('Activity', 'Cosinor', 'BCF', 'SBCF', 'BBCF', 'BSBCF', 6)
        %}
        
    pause(2.0)
