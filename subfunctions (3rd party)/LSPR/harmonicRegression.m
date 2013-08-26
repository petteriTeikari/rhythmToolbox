function [AICs,amplitudes,phases,rsquares,pvalues] = harmonicRegression(inputData,timepoints,periods,periodsNum)
%Performs harmonic regression and compute AIC
%
%   Usage:
%       [AICs,amplitudes,phases,rsquares,pvalues] = harmonicRegression(inputData,timepoints,periods,periodsNum)
%
%   INPUT��
%       inputData           - a NxM matrix representing N genes (probes) with M expression values over time 
%       timepoints          - sample time points
%       periods             - a Nx1 cell vector, N stands for genes (probes) numbers, each cell contains the periods detected by L-S
%       periodsNum          - a Nx1 vector contains number of oscillations of each genes 
%
%   OUTPUT:
%       AICs                - a Nx1 vector contains AICs of harmonic models
%       amplitudes          - a Nx1 cell vector contains amplitudes
%       phases              - a Nx1 cell vector contains phases
%       rsquares            - a Nx1 vector contains rsquares
%       pvalues             - a Nx1 vector contains pvalues

%   Copyright (C) 2010 Chen ZHANG and Rendong Yang.
%   $Revision Date: 2010/12/7 $
%//////////////////////////////////////////////////////////////////////////
%//  Authors:
%//        name            organization 					email
%//    --------------  ------------------------    ------------------------------
%//    Chen ZHANG         College of Science            zcreation@yahoo.cn
%//    Rendong Yang   College of Biological Sciences     cauyrd@gmail.com
%//
%//  Established Date:   2010/9/2
%//////////////////////////////////////////////////////////////////////////

nInputData = size(inputData,2); % number of "modalities"

% For further information about definitions of following variables,
% please see supplemental method section.
Ps = [];
Qs = [];
tempPhases = [];
tempAmplitudes = [];
AICs = [];
rsquares = [];
pvalues = [];
amplitudes = cell(nInputData,1);
phases = cell(nInputData,1);

for iInputData = 1:nInputData
        
    tempCol = (inputData(:,iInputData))';
    tempTimepoints = timepoints;
    
    nPeriods = periodsNum(iInputData,1);
    tempPeriods = periods{iInputData,1};% Cell
    nTempTimepoints = length(tempTimepoints);
    
    % Compute Ps, Qs and pvalues
    X = ones(nTempTimepoints,1+2*nPeriods);
    Y = tempCol';
    for m = 1:nTempTimepoints
        for n = 1:nPeriods
            X(m,2*n) = cos(2*pi/(tempPeriods(n))*tempTimepoints(m));
            X(m,2*n+1) = sin(2*pi/(tempPeriods(n))*tempTimepoints(m));
        end
    end
    
    [b,~,~,~,stats] = regress(Y,X);
    for n = 1:(1+2*nPeriods)/2
        Ps(n) = b(2*n);
        Qs(n) = b(2*n+1);
    end
    pvalues(iInputData,1) = stats(3);
    rsquares(iInputData,1) = stats(1);
       
    % Compute AIC   
    ss = 0;
    mu = mean(tempCol);
    k = 1;
    for l = 1:nTempTimepoints
        sum = mu;
        for n = 1:nPeriods
            sum = sum+Ps(n)*cos(2*pi/(tempPeriods(n))*tempTimepoints(l))+ Qs(n)*sin(2*pi/(tempPeriods(n))*tempTimepoints(l));
        end
        ss = ss+(sum-tempCol(k))^2;
        tempAIC = nTempTimepoints*log(ss/nTempTimepoints)+2*(2*nPeriods+2);
        AICs(iInputData,1) = tempAIC;
        k = k+1;
    end
    
    % Compute amplitudes and phases
    for iPeriod = 1:nPeriods
        v = Ps(iPeriod)-Qs(iPeriod)*i; % v is a complex number
        tempAmplitudes(iPeriod) = abs(v);
        tempPhases(iPeriod) = angle(v);
        if(tempPhases(iPeriod)<0)
            tempPhases(iPeriod) = abs(tempPhases(iPeriod))/(2*pi)*tempPeriods(iPeriod);
        else
            tempPhases(iPeriod) = tempPeriods(iPeriod)-abs(tempPhases(iPeriod))/(2*pi)*tempPeriods(iPeriod);
        end   
    end
     
    % Save amplitudes and phases
    amplitudes{iInputData,1} = tempAmplitudes;
    phases{iInputData,1} = tempPhases;
end