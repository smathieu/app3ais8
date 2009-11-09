function [ output_args ] = train_peak_count( input_args )
%TRAIN_PEAK_COUNT Summary of this function goes here
%   Detailed explanation goes here

clc
clear all
close all

global g_Pc;
global g_Pm;

%Parameters
nind = 250;     % Size of a chromosome population
g_Pc = 0.8;      % Crossover probability
g_Pm = 0.02;    % Mutation probability
ngener = 60;   % Number of generations
n_show = 10;   % Number of generations between showing the progress



falls = fuzzy_get_preprocessed_data(get_falls);
non_falls = fuzzy_get_preprocessed_data(get_non_falls);

%Falls Sensor 2
ef2 = [1, 1, 1, 1, 3, 2, 1, 1, 1, 1, 1, 1, 2, 4, 1, 1, 2, 2];
%Falls Sensor 4
ef4 = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 2];
%Non Falls Sensor 2
enf2 = [6, 2, 3, 5, 2, 1, 1, 4, 1, 3, 3, 1];
%Non Falls Sensor 3
enf3 = [2, 1, 0, 3, 3, 1, 1, 4, 2, 1, 1, 1];
%Non Falls Sensor 4
enf4 = [2, 2, 3, 5, 1, 1, 1, 3, 1, 2, 4, 1];
%Non Falls Sensor 5
enf5 = [3, 2, 0, 3, 3, 1, 2, 3, 2, 4, 1, 5];
%Non Falls Sensor 6
enf6 = [3, 2, 0, 4, 1, 0, 2, 1, 2, 3 ,1, 1];
% v = non_falls;
% for i = 1:length(v)
%     figure
%     plot(1:length(v(i).Sensor6), v(i).Sensor6);
% end

data = [];
for i = 1:length(falls)
    data = [data, ...
        struct('Data', falls(i).Sensor2, 'ExpectedPeaks', ef2(i)), ...
        struct('Data', falls(i).Sensor4, 'ExpectedPeaks', ef4(i)) ...
    ];
end
for i = 1:length(non_falls)
    data = [data, ...
        struct('Data', non_falls(i).Sensor2, 'ExpectedPeaks', enf2(i)), ...
        struct('Data', non_falls(i).Sensor3, 'ExpectedPeaks', enf3(i)) ...
        struct('Data', non_falls(i).Sensor4, 'ExpectedPeaks', enf4(i)) ...
        struct('Data', non_falls(i).Sensor5, 'ExpectedPeaks', enf5(i)) ...
        struct('Data', non_falls(i).Sensor6, 'ExpectedPeaks', enf6(i)), ...
    ];
end

% Initialize to random values
fit = zeros(1, nind);

for i = 1 : nind
    pop(i) =  makeValueStruct(rand*20, rand*20, round(rand * 50 + 1), round(rand * 50 + 3));
    pop(i) = validateIndividual(pop(i));
    fit(i) = calcIndividualFitness(data, pop(i));
end

% For all generations
total_best_fit = 0;
for m = 1 : (ngener/n_show)
   for i = 1 : n_show
       %Keep best of this generation
       [best, best_index] = max(fit);
       current = pop(best_index)
       current_fit = best / length(data)
       current_moy = mean(fit) / length(data)
       generation = (m-1)*n_show+i
       if total_best_fit < current_fit
           total_best = current;
           total_best_fit = current_fit;
       end
       
       %Generate next generation
       for j = 1 : nind 
           adam = selectBreeder(pop, fit);
           eve = selectBreeder(pop, fit);
           newpop(j) = reproduce(adam, eve);
       end
       
       % Keep best of parent
       for j = 1 : nind
           newpop(j) = validateIndividual(newpop(j));
           newfit(j) = calcIndividualFitness(data, newpop(j));
       end
       
       [pop, fit] = generate_newpop(pop, fit, newpop, newfit);
       
       
   end
end

total_best
total_best_fit

res = [];
for i = 1:length(non_falls)
    data = non_falls(i).Sensor2;
    val = findpeaks(1:length(data), data, ...
            total_best.SlopeThreshold, ...
            total_best.AmpThreshold, ...
            total_best.SmoothWidth, ...
            total_best.PeakGroup);
    res(i) = size(val, 1);
end

res = res
enf2 = enf2

function [newpop, newfit] = generate_newpop(pop, fit, newpop, newfit)
    for i = 1:5
        [dummy, index] = min(newfit);
        [p_max, i_max] = max(fit);
        newpop(index) = pop(i_max);
        newfit(index) = p_max;
        fit(i_max) = 0;
    end
    
function out = makeValueStruct(slope, amp, smooth, peak)
    out = struct(...
        'SlopeThreshold', slope, ...
        'AmpThreshold', amp, ...
        'SmoothWidth', smooth, ...
        'PeakGroup', peak);
    
function fitness = calcFitness(data, valueStruct, expected)
    
    val = findpeaks(1:length(data), data, ...
        valueStruct.SlopeThreshold, ...
        valueStruct.AmpThreshold, ...
        valueStruct.SmoothWidth, ...
        valueStruct.PeakGroup);
    peak_count = size(val, 1);
    error = abs(expected - peak_count) + 1;
    if expected == 1 && peak_count == 1
        fitness = 75;
    else
        fitness = 100/error;
    end
    
function fitness = calcIndividualFitness(data, valueStruct)
    fitness = 0;
    for i = 1 : length(data)
        fitness = fitness + calcFitness(data(i).Data, valueStruct, data(i).ExpectedPeaks);
    end

function ind = validateIndividual(ind)
    ind.SmoothWidth = max([ind.SmoothWidth, 1]);
    ind.PeakGroup = max([ind.PeakGroup, 3]);

function breeder = selectBreeder(pop, fitness)
    cumfit = sum(fitness);
    randomBreeder = rand * cumfit;
    
    for i = 1 : length(pop)
        randomBreeder = randomBreeder - fitness(i);
        if randomBreeder < 0
            breeder = pop(i);
            return;
        end
    end
    breeder = pop(length(pop));
    
function child = reproduce(adam, eve)
%     if rand < Cp
        child = cross(adam, eve);
%     else
        %Adam always win on eve
%         child = adam;
%     end
    
%     if rand < Mp
        child = mutate(child);
%     end

function child = cross(male, female)
    %TODO Change all field?
    child = makeValueStruct( ...
        crossField(male.SlopeThreshold, female.SlopeThreshold), ...
        crossField(male.AmpThreshold, female.AmpThreshold), ...
        crossField(male.SmoothWidth, female.SmoothWidth), ...
        crossField(male.PeakGroup, female.PeakGroup) ...
        );
    
function val = crossField(input1, input2)
    global g_Pc
    if rand < g_Pc
        const_scale = 10000;
        bin1 = dec2bin(input1*const_scale);
        bin2 = dec2bin(input2*const_scale);

        swap = round(rand * min([length(bin1), length(bin2)]));
        bin_output = [bin1(1 : swap), bin2(swap + 1 : length(bin2))];

        val = bin2dec(bin_output)/const_scale;
    else
        val = input1;
    end
    
function child = mutate(ind)
    %TODO Change all field?
    child = makeValueStruct( ...
        mutateField(ind.SlopeThreshold), ...
        mutateField(ind.AmpThreshold), ...
        mutateField(ind.SmoothWidth), ...
        mutateField(ind.PeakGroup) ...
        );
    
function val = mutateField(input)
    global g_Pm
    if rand < g_Pm
        const_scale = 10000;    
        bin = dec2bin(input*const_scale);

        swap = max([round(rand * length(bin)), 1]);
        if bin(swap) == '1'
            bin(swap) = '0';
        else
            bin(swap) = '1';
        end

        val = bin2dec(bin)/const_scale;
    else
        val = input;
    end