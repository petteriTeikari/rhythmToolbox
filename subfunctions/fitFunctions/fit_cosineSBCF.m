 %% Skewed Baseline Cosine Function     
function yhat = fit_cosineSBCF(x, t)     

    % assign the variables from x
    b = x(1);   H = x(2);   f = x(3);   c = x(4);   v = x(5);     

    % Skewed Baseline Cosine Function        
    yhat = b + ((H * cos(t - f + (v * cos(t - f)))) / (2 * (1 - c))) - c + abs(cos(t - f + (v * cos(t - f))) - c);
