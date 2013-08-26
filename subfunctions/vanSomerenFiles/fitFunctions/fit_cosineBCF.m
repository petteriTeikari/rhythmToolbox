%% Baseline Cosine Function    
function yhat = fit_cosineBCF(x, t)        

    % assign the variables from x
    b = x(1);   H = x(2);   f = x(3);   c = x(4);        

    % Baseline Cosine Function           
    yhat = b + ((H * cos(t - f)) / (2 * (1 - c))) - c + abs(cos(t - f) - c);
    
    whos