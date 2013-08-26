%% Bimodal Baseline Cosine Function 
function yhat = fit_cosineBBCF(x, t)

    % assign the variables from x
    b = x(1);   H = x(2);   f = x(3);   c = x(4);   m = x(5);

    % Bimodal Baseline Cosine Function        
    yhat = b + ((H * cos(t - f)) / (2 * (1 - c))) + m * cos(2*t - 2*f - pi()) ...
        - c + abs(cos(t - f) + m * cos(2*t - 2*f - pi()) - c); 