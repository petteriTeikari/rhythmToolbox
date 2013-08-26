function [x, Pxx, y, stats] = compute_periodogram(y, Fs, t, handles)             

    fprintf('    Computing periodograms\n');
    nyqFreq = Fs / 2; % Nyqvist frequency


    %% PREPROCESS the TIME SERIES, remove linear trends and smooth
    yFilt = filter_Activity(y, handles);
        
        % quick variable fix
        y_raw = y; % save the original activity;
        y_detr = yFilt.detrended;
        y = yFilt.smoothed;        
    

    %% MATLAB Amplitude spectrum
        tic;
        L = length(y_detr);
        NFFT = 2^nextpow2(L); % Next power of 2 from length of y
        Y = fft(y_detr,NFFT) /L;
        f = Fs / 2*linspace(0,1,NFFT/2+1);

        % onse sided 
        x.fft   = f((1:NFFT/2+1));       % X-vector, frequency
        Pxx.fft = 2*abs(Y(1:NFFT/2+1));  % Y-vector, amplitude
        stats.timing.fft = toc;


    %% MATLAB Periodogram
    
        % doc SPECTRUM
    

    %% Power Spectral Density estimate via Welch's method
    
        % doc WELCH
    

    %% Lomb normalized periodogram (aka Lomb-Scargle, Gauss-Vanicek or Least-Squares spectrum)
    % C. Saragiotis, Nov 2008, Matlab File Exchange

        cd(handles.path.subfunctions_3rd)                         

        % for FAST implementation            
        if handles.compSet.lomb.fastImplem == 1            
            tic;
            fprintf('        fast Lomb-Scargle\n');
            [Pxx.fastlomb, x.fastlomb, stats.alpha.fastlomb] = fastlomb(y,t); %,nyqFreq);        
            % scale the output frequency so that the highest 
            % frequency is the Nyquist frequency
            scalarMultip = nyqFreq / max(x.fastlomb);              
            x.fastlomb = scalarMultip * x.fastlomb;

            % prune non-significant periods from the periodogram if
            % wanted with a given p-value threshold
            if handles.compSet.prunePeriods_pThreshold == 1                
                Pxx.fastlomb(stats.alpha.fastlomb >= handles.compSet.lomb.pThreshold) = NaN;
            end              
            stats.timing.fastLomb = toc;
        else
            Pxx.fastlomb = []; x.fastlomb = []; stats.alpha.fastlomb = [];
        end


        % for EXACT implementation            
        if handles.compSet.lomb.exactImplem == 1
            tic;
            fprintf('         exact Lomb-Scargle\n');
            [Pxx.exactlomb, x.exactlomb, stats.alpha.exactlomb] = lomb(y,t); %,nyqFreq);        
            % scale the output frequency so that the highest frequency is the
            % Nyquist frequency
            scalarMultip = nyqFreq / max(x.fastlomb);              
            x.fastlomb = scalarMultip * x.fastlomb;

            % prune non-significant periods from the periodogram if
            % wanted with a given p-value threshold
            if handles.compSet.prunePeriods_pThreshold == 1                
                Pxx.exactlomb(stats.alpha.exactlomb >= handles.compSet.lomb.pThreshold) = NaN;
            end                
            stats.timing.exactLomb = toc;
        else
            Pxx.exactlomb = []; x.exactlomb = []; stats.alpha.exactlomb = [];
        end          
        cd(handles.path.subfunctions)


    %% ROBUST REGRESSION
    
        % Ahdesmaki, Miika, Harri Lahdesmaki, Andrew Gracey, llya Shmulevich, and Olli Yli-Harja. 
        % “Robust regression for periodicity detection in non-uniformly sampled time-course gene expression data.”
        % BMC Bioinformatics 8, no. 1 (2007): 233. MATLAB CODE provided by the authors
        % http://dx.doi.org/10.1186/1471-2105-8-233

    
    %% PICCOLO algorithm
    
        % Tominaga D. 2010. 
        % Periodicity Detection Method for Small-Sample Time Series Datasets. 
        % Bioinform Biol Insights 4:127–136. 
        % http://dx.doi.org/10.4137%2FBBI.S5983.
    
    
    %% Wavelet periodicity detection
    
        % e.g.
        % Benedetto JJ, Pfander GE. 2002. 
        % Periodic Wavelet Transforms and Periodicity Detection. 
        % SIAM Journal on Applied Mathematics 62:1329–1368. 
        % http://dx.doi.org/10.1137/S0036139900379638.
    

    %% LSPR          
        
        % Yang R, Zhang C, Su Z. 2011. 
        % LSPR: an integrated periodicity detection algorithm for unevenly sampled temporal microarray data. 
        % Bioinformatics. 
        % http://dx.doi.org/10.1093/bioinformatics/btr041.
        
        if handles.compSet.LSPR.calculateLSPR == 1

            tic;            
            cd(handles.path.LSPR)            
            LSPR_out = LSPR_wrapper(y_raw, y_detr, y, t, handles); % use a wrapper file with the steps of the algorithm          
            cd(handles.path.subfunctions)
            stats.timing.LSPR = toc; 

            % disp('LSPR')
            % disp(LSPR_out); disp(LSPR_out.period); disp(LSPR_out.amplitude); disp(LSPR_out.phase)
            Pxx.LSPR = LSPR_out.amplitude';
            x.LSPR = 1/LSPR_out.period';                        
            
            

        end            