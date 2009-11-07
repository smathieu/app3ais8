function [ output_args ] = train_peak_count( input_args )
%TRAIN_PEAK_COUNT Summary of this function goes here
%   Detailed explanation goes here

clc
clear all
close all

falls = fuzzy_get_preprocessed_data(get_falls);
non_falls = fuzzy_get_preprocessed_data(get_non_falls);

expected_peaks_falls = [1, 1, 1, 1, 3, 2, 1];
expected_peaks_nonfalls = [6, 2, 3, 5, 2, 1, 2];

for i = 1:7
    data(i) = struct('Data', falls(i).Sensor2, 'ExpectedPeaks', expected_peaks_falls(i));
end

for i = 1:7
    data(i+7) = struct('Data', non_falls(i).Sensor2, 'ExpectedPeaks', expected_peaks_nonfalls(i));
end

num = 4;

nind = 30;     % Size of a chromosome population
ngenes = num;  % Number of genes in a chromosome
Pc = 0.7;      % Crossover probability
Pm = 0.001;    % Mutation probability
ngener = 60;   % Number of generations
n_show = 10;   % Number of generations between showing the progress

% Initialize to random values
fit = zeros(1, nind);

for i = 1 : nind
    pop(i) =  makeValueStruct(rand / 10, rand, 1 + rand * 20, 3 + rand * 20);
end


% For all generations
for m = 1 : (ngener/n_show)
   for i = 1 : n_show
       for j = 1 : nind           
           pop(j) = validateIndividual(pop(j));
           fit(j) = calcIndividualFitness(data, pop(j));
       end
       [best, best_index] = max(fit);
       pop(best_index)
       best
       
       for j = 1 : nind 
           adam = findBreeder(pop, fit);
           eve = findBreeder(pop, fit);
           newpop(i) = reproduce(adam, eve);
       end
       
       
       
       
   end
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
    count = size(val, 1);
    error = abs(expected - count);
    if error == 0
        fitness = 2;
    else
        fitness = 1/error;
    end
    
function fitness = calcIndividualFitness(data, valueStruct)
    fitness = 0;
    for i = 1 : length(data)
        fitness = fitness + calcFitness(data(i).Data, valueStruct, data(i).ExpectedPeaks);
    end

function ind = validateIndividual(ind)
    ind.SmoothWidth = max([ind.SmoothWidth, 1]);
    ind.PeakGroup = max([ind.SmoothWidth, 3]);

function breeder = selectBreeder(pop, fitness)
    cumfit = sum(fitness);
    randomBreeder = rand * cumfit;
    
    for i = 1 : length(pop)
        randomBreeder = randomBreeder - fitness(i);
        if fitness(i) < 0
            breeder = pop(j);
            return;
        end
    end
    breeder = pop(length(pop));
    
function child = reproduce(adam, eve, Cp, Mp)
        
