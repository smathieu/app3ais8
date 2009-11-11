function train_peak_count
% Genetic algorithm to optimize the parameters of findpeak

clc
clear all
close all

global g_Pc;
global g_Pm;

% Parameters
nind = 250;    % Size of a chromosome population
g_Pc = 0.8;    % Crossover probability
g_Pm = 0.02;   % Mutation probability
ngener = 60;   % Number of generations
n_show = 10;   % Number of generations between showing the progress


% Load data
falls = fuzzy_get_preprocessed_data(get_falls);
falls = falls(1:5:length(falls)); % Only use first of 5 tries
non_falls = fuzzy_get_preprocessed_data(get_non_falls);
non_falls = non_falls(1:5:length(non_falls)); % Only use first of 5 tries

% Expected peak count
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

% Keep falls data
data = [];
for i = 1:length(falls)
    data = [data, ...
        struct('Data', falls(i).Sensor2, 'ExpectedPeaks', ef2(i)), ...
        struct('Data', falls(i).Sensor4, 'ExpectedPeaks', ef4(i)) ...
    ];
end

% Keep non-falls data
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
for m = 1 : (ngener / n_show)
   for i = 1 : n_show
       % Keep best of this generation
       [best, best_index] = max(fit);
       current = pop(best_index)
       current_fit = best / length(data)
       current_moy = mean(fit) / length(data)
       generation = (m - 1) * n_show + i
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
       
       % Keep fitest parents
       for j = 1 : nind
           newpop(j) = validateIndividual(newpop(j));
           newfit(j) = calcIndividualFitness(data, newpop(j));
       end
       [pop, fit] = generate_newpop(pop, fit, newpop, newfit);
   end
end

% Display best
total_best
total_best_fit

% Test best
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

% Display result with Non Falls Sensor 2
res = res
enf2 = enf2

function [newpop, newfit] = generate_newpop(pop, fit, newpop, newfit)
% Replace worst 5 children by 5 best parents
% Input :
%   pop : Parents population
%   fit : Parents fitness
%   newpop : Children population
%   newfit : Children fitness
% Output :
%   newpop : New children generation
%   newfit : New children fitness

    for i = 1:5
        [dummy, index] = min(newfit);
        [p_max, i_max] = max(fit);
        newpop(index) = pop(i_max);
        newfit(index) = p_max;
        fit(i_max) = 0;
    end
    
function out = makeValueStruct(slope, amp, smooth, peak)
% Factory method to create individual
%   See findpeak.m for more explanation on parameters
% Input :
%   slope : First parameter of findpeak
%   amp : Second parameter of findpeak
%   smooth : Third parameter of findpeak
%   peak : Fourth parament of findpeak

    out = struct(...
        'SlopeThreshold', slope, ...
        'AmpThreshold', amp, ...
        'SmoothWidth', smooth, ...
        'PeakGroup', peak);
    
function fitness = calcFitness(data, valueStruct, expected)
% Calcul fitness of one individual for one input data
% Input :
%   data : An input sample
%   valueStruct : The individual
%   expected : Expected result
% Output :
%   fitness : Value of fitness calculated

    val = findpeaks(1 : length(data), data, ...
        valueStruct.SlopeThreshold, ...
        valueStruct.AmpThreshold, ...
        valueStruct.SmoothWidth, ...
        valueStruct.PeakGroup);
    peak_count = size(val, 1);
    error = abs(expected - peak_count) + 1;
    if expected == 1 && peak_count == 1
        fitness = 75;
    else
        fitness = 100 / error;
    end
    
function fitness = calcIndividualFitness(data, valueStruct)
% Calcul fitness of one individual for all input data
% Input : 
%   data : All input data
%   valueStruct : The individual
% Output :
%   fitness : Value of fitness calculated

    fitness = 0;
    for i = 1 : length(data)
        fitness = fitness + calcFitness(data(i).Data, valueStruct, data(i).ExpectedPeaks);
    end

function ind = validateIndividual(ind)
% Validate parameters are within certain bounds
% Input :
%   ind : The individual to validate
% Output :
%   ind : The validated individual

    ind.SmoothWidth = max([ind.SmoothWidth, 1]);
    ind.PeakGroup = max([ind.PeakGroup, 3]);

function breeder = selectBreeder(pop, fitness)
% Select an individual in the population for parent
%   The probability of an individual to be selected depends on the
%   individual's fitness
% Input :
%   pop : Array of the population
%   fitness : Array of the population fitness
% Output :
%   breeder : Selected individual

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
    
function cain = reproduce(adam, eve)
% Cross and mutate 2 parents to generate a child
% Input :
%   adam : The male parent
%   eve : The female parent
% Output :
%   cain : The produced child

        cain = cross(adam, eve);
        cain = mutate(child);

function child = cross(male, female)
% Cross each individual parameters
% Input :
%   male : Adam
%   female : Eve
% Output :
%   child : Cain
    
    child = makeValueStruct( ...
        crossField(male.SlopeThreshold, female.SlopeThreshold), ...
        crossField(male.AmpThreshold, female.AmpThreshold), ...
        crossField(male.SmoothWidth, female.SmoothWidth), ...
        crossField(male.PeakGroup, female.PeakGroup) ...
        );
    
function val = crossField(input1, input2)
% Use global g_Pc probabilities to randomly cross input1 and input2.
%   When the cross occurs, a random pivot point is found and we keep the
%   beginning of input1 and the end of input2.
% Input :
%   input1 : First value
%   input2 : Second value
% Output :
%   val : Crossed value

    global g_Pc
    if rand < g_Pc
        const_scale = 10000;
        bin1 = dec2bin(input1*const_scale);
        bin2 = dec2bin(input2*const_scale);

        swap = round(rand * min([length(bin1), length(bin2)]));
        bin_output = [bin1(1 : swap), bin2(swap + 1 : length(bin2))];

        val = bin2dec(bin_output) / const_scale;
    else
        val = input1;
    end
    
function child = mutate(ind)
% Maybe mutate all variables for one individual
% Input :
%   ind : Indivdual to mutate
% Output :
%   child : Mutated individual

    child = makeValueStruct( ...
        mutateField(ind.SlopeThreshold), ...
        mutateField(ind.AmpThreshold), ...
        mutateField(ind.SmoothWidth), ...
        mutateField(ind.PeakGroup) ...
        );
    
function val = mutateField(input)
% Use global g_Pm probabilities to mutate or not the input
% Input :
%   input : Input to mutate
% Output :
%   val : Mutated value

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

        val = bin2dec(bin) / const_scale;
    else
        val = input;
    end