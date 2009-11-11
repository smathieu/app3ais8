function [peaks] = find_peak2(data, max_ratio)
    max_value = max(data);
    threshold = max_ratio * max_value;
    peaks = 0;
    for i = 2 : length(data)
        if data(i-1) < threshold && data(i) >= threshold
            peaks = peaks + 1;
        end
    end