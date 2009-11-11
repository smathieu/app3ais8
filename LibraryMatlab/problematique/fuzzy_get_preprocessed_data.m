function data_struct = fuzzy_get_preprocessed_data(data_struct)
% Transform the data so fuzzy logic can process it
    for i = 1:length(data_struct)
        data_struct(i).Sensor1 = preprocess_data(data_struct(i).Sensor1);
        data_struct(i).Sensor2 = preprocess_data(data_struct(i).Sensor2);
        data_struct(i).Sensor3 = preprocess_data(data_struct(i).Sensor3);
        data_struct(i).Sensor4 = preprocess_data(data_struct(i).Sensor4);
        data_struct(i).Sensor5 = preprocess_data(data_struct(i).Sensor5);
        data_struct(i).Sensor6 = preprocess_data(data_struct(i).Sensor6);
    end

function output_data = preprocess_data(data)
% Preprocess the data
% Input :
%   data : Data to preprocess
% Output :
%   output_data : Preprocessed data

    Fe = 2000;
    f = 20;

    output_data = data;
    output_data = downsample_signal(output_data, f, Fe);
    output_data = diff(output_data);