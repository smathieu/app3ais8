function fuzzy_app3
% Entry point for fuzzy logic demonstration. Execute this function to see
% execution benchmark and test results for all given samples.

    close all
    clear all
    clc
    
    % Switch those 2 lines to change between 2 and 3 input values 
    %  (see values variable near line 69)
%     fuzzy_logic_fis = readfis('fuzzy_2.fis');
    fuzzy_logic_fis = readfis('fuzzy_3.fis');

    falls = get_falls;
    non_falls = get_non_falls;

    % Execution benchmark
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
    
    % Time to execute is corrupted on first tries because it needs to load code.
    time_min = min(time(3:length(time)))
    time_mean = mean(time(3:length(time)))
    time_max = max(time(3:length(time)))


% Test on all given examples

% k => For binary search of threshold value
%  for k = 1:20
%     threshold = 0.35 + (k-1)/100
    threshold = 0.42;
    
    [f_falls_count, f_non_falls_count] = eval_fuzzy(falls, fuzzy_logic_fis, threshold);
    [nf_falls_count, nf_non_falls_count] = eval_fuzzy(non_falls, fuzzy_logic_fis, threshold);

    display_result(f_non_falls_count, f_falls_count + f_non_falls_count, nf_falls_count, nf_falls_count + nf_non_falls_count);
%  end

function [falls_count, non_falls_count] = eval_fuzzy(values, fuzzy_logic_fis, threshold)
% Execute fuzzy logic
% Input :
%   values : given examples
%   fuzzy_logic_fis : read fuzzy logic file (*.fis)
%   threshold = Threshold between falls and non falls
%
% Output :
%   falls_count : Number of falls
%   non_falls_count : Number of non falls

%     threshold = 0.40; % Comment this line when testing fuzzy with 2 input
    falls_count = 0;
    non_falls_count = 0;
    for i = 1:length(values)
        data = values(i);
        
        a4 = downsample_signal(data.Sensor4, 100, 2000);
        a5 = downsample_signal(data.Sensor5, 100, 2000);
        a6 = downsample_signal(data.Sensor6, 100, 2000);
        inputs = [abs(abs(max(a6)) - abs(min(a6))), ...
                  abs(abs(max(a5)) - abs(min(a5))), ...
                  abs(abs(max(a4)) - abs(min(a4))) ... % Comment this line with "..." when testing fuzzy with 2 input
                  ];
        output = evalfis(inputs, fuzzy_logic_fis);
        
        if(output >= threshold)
            falls_count = falls_count + 1;
        else
            non_falls_count = non_falls_count + 1;
        end
    end