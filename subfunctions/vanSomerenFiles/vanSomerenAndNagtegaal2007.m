function [out,timeExec] = vanSomerenAndNagtegaal2007(t,y,handles)

    % Bounds for the optimized variables (i.e. constraints)
    % you can set the high and low to be the same if you want to keep
    % it constant during the optimization process                      

    % Init and bound values for the optimization process
    fitOptions.initValues  = handles.compSet.cosineFit.init;   % INIT Values
    fitOptions.bounds      = handles.compSet.cosineFit.bounds; % BOUNDS for the allowed parameter values                                    

    out.tRad = (linspace(0,handles.wMax,length(t)))';

    % fit a Baseline Cosine Function
    tic; fitOptions.cosineType = 'fit_cosineBCF'; disp('     . BCF fit')
    out.BCF = fit_mainCosineFitting(out.tRad, y, fitOptions, handles);               
    timeExec.BCF = toc;

    % fit a Skewed Baseline Cosine Function (SBCF)
    tic; fitOptions.cosineType = 'fit_cosineSBCF'; disp('     . SBCF fit')
    out.SBCF = fit_mainCosineFitting(out.tRad, y, fitOptions, handles);
    timeExec.SBCF = toc;

    % fit a Bimodal Baseline Cosine Function (Bimodal BCF)
    tic; fitOptions.cosineType = 'fit_cosineBBCF';  disp('     . BBCF fit')
    out.BBCF = fit_mainCosineFitting(out.tRad, y, fitOptions, handles);
    timeExec.BBCF = toc;

    % fit a Bimodal Skewed Baseline Cosine Function (Bimodal SBCF)
    tic; fitOptions.cosineType = 'fit_cosineBSBCF'; disp('     . BSBCF fit')
    out.BSBCF = fit_mainCosineFitting(out.tRad, y, fitOptions, handles);
    timeExec.BSBCF = toc;       