function count = get_peak_count(data)
%     for i = 1:10
%         for j = 3:10
%         i = i
%         j = j
%         val = findpeaks(1:length(data), data, 0.001, 13, i, j)
%         end
%     val = findpeaks(1:length(data), data, 0.3925, 2.2131, 4, 49);
    
%       val = findpeaks(1:length(data), data, 0.2196, 1.7053, 5.4120, 29.1707);
%     count = size(val, 1);
    count = find_peak2(data, 0.65);
    end