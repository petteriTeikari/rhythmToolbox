%% Main SUBFUNCTION for cosine fitting defined 
function out = fit_mainCosineFitting(t, y, fitOptions, handles)

    % t - time, must be scaled so that only period is there

    % use short variable names
    init = fitOptions.initValues;
    bds  = fitOptions.bounds;

    % The definition of initial values and bounds depend on the type of
    % cosine fit as they do not have the same amount of free parameters
    % Also CUSTOM definition per given model is possible in this
    % if-elseif condition structure
    if strcmp(fitOptions.cosineType, 'fit_cosineBCF');
        x0         = [init.b   init.H   init.f   init.c];
        lb         = [bds.b(1) bds.H(1) bds.f(1) bds.c(1)];
        ub         = [bds.b(2) bds.H(2) bds.f(2) bds.c(2)];

    elseif strcmp(fitOptions.cosineType, 'fit_cosineSBCF');
        x0         = [init.b   init.H   init.f   init.c   init.v];
        lb         = [bds.b(1) bds.H(1) bds.f(1) bds.c(1) bds.v(1)];
        ub         = [bds.b(2) bds.H(2) bds.f(2) bds.c(2) bds.v(2)];

    elseif strcmp(fitOptions.cosineType, 'fit_cosineBBCF');
        x0         = [init.b   init.H   init.f   init.c   init.m];
        lb         = [bds.b(1) bds.H(1) bds.f(1) bds.c(1) bds.m(1)];
        ub         = [bds.b(2) bds.H(2) bds.f(2) bds.c(2) bds.m(2)];

    elseif strcmp(fitOptions.cosineType, 'fit_cosineBSBCF');
        x0         = [init.b   init.H   init.f   init.c   init.v   init.m];
        lb         = [bds.b(1) bds.H(1) bds.f(1) bds.c(1) bds.v(1) bds.m(1)];
        ub         = [bds.b(2) bds.H(2) bds.f(2) bds.c(2) bds.v(2) bds.m(2)];

    end

    % Solve nonlinear least-squares (nonlinear data-fitting) problems
    % requires Optimization Toolbox

        % We use lsqcurvefit [nonlinear curve-fitting (data-fitting)
        % problem in least-squares sense] for our problem, good demo:
        % http://blinkdagger.com/matlab/matlab-curve-fitting-data-using-lsqcurvefit/

        % fmincon that could be run in parallel mode
        % http://www.mathworks.com/products/optimization/demos.html?file=/products/demos/shipping/optim/optimparfor.html

        % other alternative would be 'lsqnonlin',
        % e.g. http://www.mathworks.com/support/solutions/en/data/1-18DGY/?solution=1-18DGY


    % define the fitting options for the optimization routine
    options = optimset('MaxIter',400,'MaxFunEvals',10000);        
    options = optimset(options,'UseParallel','always'); % use multiple CPU cores if available, remember to use matlabpool

    % Call lsqcurvefit
    fh = str2func(fitOptions.cosineType); % construct the function handle from the string
    currDir = pwd; 
    cd(handles.path.fitFunctions)
    whos
    [out.x, out.resnorm, out.residual] = lsqcurvefit(fh, x0, t, y, lb, ub, options); 
    cd(currDir)
    