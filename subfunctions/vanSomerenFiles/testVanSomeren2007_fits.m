function testVanSomeren2007_fits(x,y)

    if nargin == 0
        load('inputDataForCosineFitting.mat')
        ind1 = 30;
        ind2 = 47;
        x = t(ind1:ind2);
        t = x;
        y = y(ind1:ind2);
        y = y / max(y);
    else       
       
    end
    
    codePath = mfilename('fullpath');
    handles.codePath = strrep(codePath,'testVanSomeren2007_fits',''); % Removing the filename from the path
    handles.path.fitFunctions = fullfile(handles.codePath, 'fitFunctions');
    
    close all
    fig = figure('Color', 'w');    
    hold on
    p(1) = plot(x, y, 'ok'); % original data
        set(p(1), 'MarkerFaceColor', [0.65 0.18 0])        
    
    % cycle length for cosinor analysis
        w = 24; % [hours]        
        handles.wMax = 2*pi(); % max angular freq
    
    %% cosinor
    
      % type I error used for cofidence interval calculations. Usually 
      % set to be 0.05 which corresponds with 95% cofidence intervals
      alpha = 0.05;   
    
    %% call subfunction for van Someren (2007)
    
        % handles, additional parameters for the fit
        
        % Cosine fit parameters

            % default INIT VALUES for the optimization process
            handles.compSet.cosineFit.init.b = 1;   % baseline level
            handles.compSet.cosineFit.init.H = 50;  % height (i.e., peak level)
            handles.compSet.cosineFit.init.v = 0.3; % skewness
            handles.compSet.cosineFit.init.c = 0.2; % width 
            handles.compSet.cosineFit.init.f = 0.6; % phi, the phase in radians
            handles.compSet.cosineFit.init.m = 0.3; % bimodality parameter

            % BOUNDS for the optimization [lowerBound upperBound]
            handles.compSet.cosineFit.bounds.b = [0 Inf];   % baseline level
            handles.compSet.cosineFit.bounds.H = [0 Inf];   % height (i.e., peak level)
            handles.compSet.cosineFit.bounds.v = [-1 1];    % skewness
            handles.compSet.cosineFit.bounds.c = [-1 1];    % width 
            handles.compSet.cosineFit.bounds.f = [0 Inf];   % phi, the phase in radians
            handles.compSet.cosineFit.bounds.m = [0 1];     % bimodality parameter       
    
        % call the subfunction
        [out, timeExec] = vanSomerenAndNagtegaal2007(x, y, handles);
        %         a = out.tRad
        %         b = out.BCF.x
        %         whos
       
        % Plot the fits
        cd(handles.path.fitFunctions)
        p(3) = plot(t, fit_cosineBCF(out.BCF.x, out.tRad), '--b'); % plot
        p(4) = plot(t, fit_cosineSBCF(out.SBCF.x, out.tRad), 'r'); % plot
        p(5) = plot(t, fit_cosineBBCF(out.BBCF.x, out.tRad), 'g'); % plot
        p(6) = plot(t, fit_cosineBSBCF(out.BSBCF.x, out.tRad), 'k'); % plot
        legend('Data', 'BCF', 'SBCF', 'BBCF', 'BSBCF', 6, 'Location', 'Best')
            legend('boxoff')
        export_fig('vanSomerenCosFit_demo.png', '-r200', '-a2')
      
        cd(handles.codePath)