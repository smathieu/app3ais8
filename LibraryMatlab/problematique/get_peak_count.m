function count = get_peak_count(data)
%     for i = 1:10
%         for j = 3:10
%         i = i
%         j = j
%         val = findpeaks(1:length(data), data, 0.001, 13, i, j)
%         end

    val = findpeaks(1:length(data), data, 0.001, 10, 4, 6);
    count = size(val, 1);
    end