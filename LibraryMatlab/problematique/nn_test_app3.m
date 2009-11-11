% DSPIRALE Distinction entre deux spirales
function errors = nn_test_app3(net)
    % Input

    Fe = 2000;
    f = 20;
    
    fixed_sample_size = 8000;
    samples_per_channel = f / Fe * fixed_sample_size;
    num_constants = 2;

    S3_falls = [ ...
        '3ITB1A'; ...
        '3ITB1B'; ...
        '3ITB1C'; ...
        '3ATF2A'; ...
        '3ATF2B'; ...
        '3ATF2C'; ...
        '3SVF3A'; ...
        '3SVF3B'; ...
        '3SVF3C'; ...
        ];
    
    S5_falls = [ ...
        '5ITB1A'; ...
        '5ITB1B'; ...
        '5ITB1C'; ...
        '5ATF2A'; ...
        '5ATF2B'; ...
        '5ATF2C'; ...
        '5SVF3A'; ...
        '5SVF3B'; ...
        '5SVF3C'; ...
        ];

    S3_non_falls = [ ...
        '3ITB1D'; ...
        '3ATF2D'; ...
        '3NNC4A'; ...
        '3NNC4B'; ...
        '3NNC4C'; ...
        '3NNC4D'; ...
        ];
    
    S5_non_falls = [ ...
        '5ITB1D'; ...
        '5ATF2D'; ...
        '5NNC4A'; ...
        '5NNC4B'; ...
        '5NNC4C'; ...
        '5NNC4D'; ...
        ];
    
    data_falls = [];
    data_non_falls = [];
    
    for i = 1 : length(S3_falls)
        file = S3_falls(i, :);
        for j = 1:5
            ext = sprintf('00%d', j);
            data = load_file('Sujet_3', file, ext);
            data_row = [];
            for k=2:6
                channel_max = max(data(:,k));
                channel_min = min(data(:,k));

                data_row(1+(k-2)*num_constants:(k-1)*num_constants) = [channel_max, channel_min];
            end
            S3_data_falls((i-1)*5+j, :) = [data_row 1 0];
        end
    end
  
    % Plot non falls
    for i = 1 : length(S3_non_falls)
        file = S3_non_falls(i, :);
        for j = 1:5
            ext = sprintf('00%d', j);
            data = load_file('Sujet_3', file, ext);
            cory_data_row = [];
            for k=2:6
                channel_max = max(data(:,k));
                channel_min = min(data(:,k));

                cory_data_row(1+(k-2)*num_constants:(k-1)*num_constants) = [channel_max, channel_min];
            end
            S3_data_non_falls((i-1)*5+j, :) = [cory_data_row 0 1];
        end
    end
    
    for i = 1 : length(S5_falls)
        file = S5_falls(i, :);
        for j = 1:5
            ext = sprintf('00%d', j);
            data = load_file('Sujet_5', file, ext);
            data_row = [];
            % Downsample the signals from channels 2 to 6
            for k=2:6
                channel_max = max(data(:,k));
                channel_min = min(data(:,k));

                data_row(1+(k-2)*num_constants:(k-1)*num_constants) = [channel_max, channel_min];
            end
            S5_data_falls((i-1)*5+j, :) = [data_row 1 0];
        end
    end
  
    % Plot non falls
    for i = 1 : length(S5_non_falls)
        file = S5_non_falls(i, :);
        for j = 1:5
            ext = sprintf('00%d', j);
            data = load_file('Sujet_5', file, ext);
            cory_data_row = [];
            for k=2:6
                channel_max = max(data(:,k));
                channel_min = min(data(:,k));

                cory_data_row(1+(k-2)*num_constants:(k-1)*num_constants) = [channel_max, channel_min];
            end
            S5_data_non_falls((i-1)*5+j, :) = [cory_data_row 0 1];
        end
    end

    testing_data = [S3_data_falls; S5_data_falls; S3_data_non_falls; S5_data_non_falls];
    
    testing_input = testing_data(:, 1:5*num_constants)';
    testing_output = testing_data(:, (5*num_constants)+1:(5*num_constants)+2)';
    [R, Q] = size(testing_input); % Structure d'entree et de sortie du RNA
    [S2, Q] = size(testing_output);
   
    % 
    % %    Training begins...please wait...
    % 
    P = testing_input;
    T = testing_output;
    size(P);
    size(T);

    % 
    % PERFORM THE TEST
    A = sim(net,P);
    for i = 1 : size(A, 2)
        if A(1,i) < A(2,i)
            AA(i) = 0;
        else
            AA(i) = 1;
        end
    end

    for i = 1 : size(T, 2)
        if T(1,i) < T(2,i)
            TT(i) = 0;
        else
            TT(i) = 1;
        end
    end
    errors = sum(abs(AA-TT));
    
    errors_falls = sum(abs(AA(1:90)-TT(1:90)));
    errors_non_falls = sum(abs(AA(91:150)-TT(91:150)));
    
    display_result(errors_falls, 90, errors_non_falls, 60);