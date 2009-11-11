%Fuzzy logic
function fuzzy_app3
    close all
    clear all
    clc
    
    
%     fuzzy_logic_fis = readfis('stupid_fuzzy_2.fis');
    fuzzy_logic_fis = readfis('stupid_fuzzy2.fis');

    falls = get_falls;
    non_falls = get_non_falls;

% Get time  
time = [];
for i = 1:length(falls)
    tic
    eval_fuzzy(falls(i), fuzzy_logic_fis, 0.42);
    time = [time, toc];
end
for i = 1:length(non_falls)
    tic
    eval_fuzzy(non_falls(i), fuzzy_logic_fis, 0.42);
    time = [time, toc];
end
%Time to execute is corrupted on first tries because it needs to load code.
time_min = min(time(3:length(time)))
time_mean = mean(time(3:length(time)))
time_max = max(time(3:length(time)))


% Get %
%  for k = 1:20
%     threshold = 0.35 + (k-1)/100
    threshold = 0.42;
    
    [f_falls_count, f_non_falls_count] = eval_fuzzy(falls, fuzzy_logic_fis, threshold);
    [nf_falls_count, nf_non_falls_count] = eval_fuzzy(non_falls, fuzzy_logic_fis, threshold);

    display_result(f_non_falls_count, f_falls_count + f_non_falls_count, nf_falls_count, nf_falls_count + nf_non_falls_count);
%  end

function [falls_count, non_falls_count] = eval_fuzzy(values, fuzzy_logic_fis, threshold)
    falls_count = 0;
    non_falls_count = 0;
    for i = 1:length(values)
        data = values(i);
        
        a4 = downsample_signal(data.Sensor4, 100, 2000);
        a5 = downsample_signal(data.Sensor5, 100, 2000);
        a6 = downsample_signal(data.Sensor6, 100, 2000);
        inputs = [abs(abs(max(a6))-abs(min(a6))), ...
                  abs(abs(max(a5))-abs(min(a5))), ... % Comment this line with "..." when testing fuzzy with 2 input 
                  abs(abs(max(a4))-abs(min(a4))) ...
                  ];
        output = evalfis( inputs, fuzzy_logic_fis);
        
        if( output >= threshold )
            falls_count = falls_count + 1;
        else
            non_falls_count = non_falls_count + 1;
        end
    end