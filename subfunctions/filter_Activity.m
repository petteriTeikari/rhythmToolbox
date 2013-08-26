function yFilt = filter_Activity(y, handles)

    % remove first the mean
    y = y - nanmean(y);

    % remove linear trend
    yFilt.detrended = detrend(y); % the default matlab function

    % smooth
    yFilt.smoothed = smooth(yFilt.detrended, 'sgolay', 4); % 4th order Savitzky-Golay        
