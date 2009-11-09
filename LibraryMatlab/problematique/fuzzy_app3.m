%Fuzzy logic
function fuzzy_app3
    close all
    clear all
    clc
    
    fuzzy_logic_fis = readfis('stupid_fuzzy.fis');
%     falls = fuzzy_get_preprocessed_data(get_falls);
%     non_falls = fuzzy_get_preprocessed_data(get_non_falls);
    falls = get_falls;
    non_falls = get_non_falls;


 for k = 1:15
    f_falls_count = 0;
    f_non_falls_count = 0;
    values = falls;
    for i = 1:length(values)
        data = values(i);
        
        a4 = downsample_signal(data.Sensor4, 100, 2000);
        a5 = downsample_signal(data.Sensor5, 100, 2000);
        a6 = downsample_signal(data.Sensor6, 100, 2000);
        inputs = [abs(abs(max(a6))-abs(min(a6))), ...
                  abs(abs(max(a5))-abs(min(a5))), ...
                  abs(abs(max(a4))-abs(min(a4))) ...
                  ];
%         inputs = [ ...
%             get_peak_count(data.Sensor2), ...
%             get_peak_count(data.Sensor3), ...
%             get_peak_count(data.Sensor5), ...
%             get_peak_count(data.Sensor6) ...
%             ]
        output = evalfis( inputs, fuzzy_logic_fis);
        
        if( output >= (0.35 + k/100) )
%         if( output >= (0.44) )
            f_falls_count = f_falls_count + 1;
        else
            f_non_falls_count = f_non_falls_count + 1;
        end
    end
    
    threshold = 0.35 + k/100
    f_total = f_falls_count + f_non_falls_count;
    fprintf('F  : Falls : %d/%d => %d\n', f_falls_count, f_total, round(f_falls_count/f_total*100))
    fprintf('F  : Non falls : %d/%d => %d\n', f_non_falls_count, f_total, round(f_non_falls_count/f_total*100))
    
    nf_falls_count = 0;
    nf_non_falls_count = 0;
    values = non_falls;
    for i = 1:length(values)
        data = values(i);
        
        a4 = downsample_signal(data.Sensor4, 100, 2000);
        a5 = downsample_signal(data.Sensor5, 100, 2000);
        a6 = downsample_signal(data.Sensor6, 100, 2000);
        inputs = [abs(abs(max(a6))-abs(min(a6))), ...
                  abs(abs(max(a5))-abs(min(a5))), ...
                  abs(abs(max(a4))-abs(min(a4))) ...
                  ];
%         inputs = [ ...
%             get_peak_count(data.Sensor2), ...
%             get_peak_count(data.Sensor3), ...
%             get_peak_count(data.Sensor5), ...
%             get_peak_count(data.Sensor6) ...
%             ]
        output = evalfis( inputs, fuzzy_logic_fis);
        
        if( output >= (0.35 + k/100) )
%         if( output >= (0.44) )
            nf_falls_count = nf_falls_count + 1;
        else
            nf_non_falls_count = nf_non_falls_count + 1;
        end
    end
    
    nf_total = nf_falls_count + nf_non_falls_count;
    fprintf('NF : Falls : %d/%d => %d\n', nf_falls_count, nf_total, round(nf_falls_count/nf_total*100))
    fprintf('NF : Non falls : %d/%d => %d\n', nf_non_falls_count, nf_total, round(nf_non_falls_count/nf_total*100))
    
    moy = (round(f_falls_count/f_total*100) + round(nf_non_falls_count/nf_total*100))/2
end