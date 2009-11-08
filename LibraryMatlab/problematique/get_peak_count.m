function count = get_peak_count(data)
%     for i = 1:10
%         for j = 3:10
%         i = i
%         j = j
%         val = findpeaks(1:length(data), data, 0.001, 13, i, j)
%         end

    %val = findpeaks(1:length(data), data, 0.001, 10, 4, 6);
    val = findpeaks(1:length(data), data, 1.0096, 0.4426, 4.9287, 3);
%     val = findpeaks(1:length(data), data, 0.4685, 0.6404, 22.8902, 28.4763);
    count = size(val, 1);
    end