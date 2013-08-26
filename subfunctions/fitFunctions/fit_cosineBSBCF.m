%% Bimodal Skewed Baseline Cosine
function yhat = fit_cosineBSBCF(x, t)

    % assign the variables from x
    b = x(1);   H = x(2);   f = x(3);   c = x(4);   v = x(5);   m = x(6);

    % Bimodal Skewed Baseline Cosine
    yhat = b + ((H * cos(t - f + (v * cos(t - f)))) / (2 * (1 - c))) ...
        + m * cos(2*t - 2*f - pi()) - c ... 
        + abs(cos(t - f + (v * cos(t - f))) ...
        + (m * cos(2*t - 2*f - pi()) - c));        
