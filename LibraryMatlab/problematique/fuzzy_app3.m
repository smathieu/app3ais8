%Fuzzy logic
function fuzzy_app3
    close all
    clear all
    clc
    
    fuzzy_logic_fis = readfis('fuzzy.fis');
    falls = fuzzy_get_preprocessed_data(get_falls);
    non_falls = fuzzy_get_preprocessed_data(get_non_falls);

    % Optimize get_peak_count
%     data = non_falls(6).Sensor1;
%     plot(data)
%     get_peak_count(data);
    
    falls_count = 0;
    non_falls_count = 0;
    values = non_falls;
    for i = 1:length(values)
        data = values(i);
        inputs = [ ...
            get_peak_count(data.Sensor2), ...
            get_peak_count(data.Sensor3), ...
            get_peak_count(data.Sensor5), ...
            get_peak_count(data.Sensor6) ...
            ]
        output = evalfis( inputs, fuzzy_logic_fis)
        
        if( output >= 0.5 )
            falls_count = falls_count + 1;
        else
            non_falls_count = non_falls_count + 1;
        end
    end
    
    total = falls_count + non_falls_count;
    fprintf('Falls : %d/%d => %d\n', falls_count, total, round(falls_count/total*100))
    fprintf('Non falls : %d/%d => %d\n', non_falls_count, total, round(non_falls_count/total*100))