function count = get_peak_count(data)
% Find the number of peaks in a data set
% Input :
%   data : Data on which we want to find peaks
% Output :
%   count : Number of peaks found

    val = findpeaks(1:length(data), data, 0.2196, 1.7053, 5.4120, 29.1707);
    count = size(val, 1);
    end