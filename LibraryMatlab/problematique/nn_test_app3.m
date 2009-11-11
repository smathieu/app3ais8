function errors = nn_test_app3(net)
% nn_test_app3 : Tests a neural network on the identification of the falls
% and non falls for the complete set of data.
%
% Parameters :
%   net : The neural network to test
%
% Outputs : 
%   errors : The total number of errors on all the data (150 samples)
    % Number of significant constants used per channel
    num_constants = 2;

    data_falls = get_falls();
    data_non_falls = get_non_falls();
    
    % Load the inputs for all subjects
    for i = 1 : length(data_falls)
        channel_max2 = max(data_falls(i).Sensor2);
        channel_min2 = min(data_falls(i).Sensor2);

        channel_max3 = max(data_falls(i).Sensor3);
        channel_min3 = min(data_falls(i).Sensor3);

        channel_max4 = max(data_falls(i).Sensor4);
        channel_min4 = min(data_falls(i).Sensor4);

        channel_max5 = max(data_falls(i).Sensor5);
        channel_min5 = min(data_falls(i).Sensor5);

        channel_max6 = max(data_falls(i).Sensor6);
        channel_min6 = min(data_falls(i).Sensor6);

        input_data_falls(i, :) = [...
            channel_max2 channel_min2 ...
            channel_max3 channel_min3 ...
            channel_max4 channel_min4 ...
            channel_max5 channel_min5 ...
            channel_max6 channel_min6 ...
            1 0];
    end

  
    % Load the inputs for all subjects
    for i = 1 : length(data_non_falls)
        channel_max2 = max(data_non_falls(i).Sensor2);
        channel_min2 = min(data_non_falls(i).Sensor2);

        channel_max3 = max(data_non_falls(i).Sensor3);
        channel_min3 = min(data_non_falls(i).Sensor3);
        
        channel_max4 = max(data_non_falls(i).Sensor4);
        channel_min4 = min(data_non_falls(i).Sensor4);
        
        channel_max5 = max(data_non_falls(i).Sensor5);
        channel_min5 = min(data_non_falls(i).Sensor5);
        
        channel_max6 = max(data_non_falls(i).Sensor6);
        channel_min6 = min(data_non_falls(i).Sensor6);
        
        input_data_non_falls(i, :) = [...
            channel_max2 channel_min2 ...
            channel_max3 channel_min3 ...
            channel_max4 channel_min4 ...
            channel_max5 channel_min5 ...
            channel_max6 channel_min6 ...
            0 1];
    end

    testing_data = [input_data_falls; input_data_non_falls];
    
    testing_input = testing_data(:, 1:5*num_constants)';
    testing_output = testing_data(:, (5*num_constants)+1:(5*num_constants)+2)';
    
    % Use the network to determine the outputs for each input
    A = sim(net,testing_input);
    
    % Assign a class to each output, depending on which output is the
    % biggest
    AA = zeros(size(A,2));
    for i = 1 : size(A, 2)
        if A(1,i) < A(2,i)
            AA(i) = 0;
        else
            AA(i) = 1;
        end
    end

    % Compare each output to the expected output
    TT = zeros(size(testing_output, 2));
    for i = 1 : size(testing_output, 2)
        if testing_output(1,i) < testing_output(2,i)
            TT(i) = 0;
        else
            TT(i) = 1;
        end
    end
    
    errors = sum(abs(AA-TT));
    
    errors_falls = sum(abs(AA(1:90)-TT(1:90)));
    errors_non_falls = sum(abs(AA(91:150)-TT(91:150)));
    
    display_result(errors_falls, 45, errors_non_falls, 30);