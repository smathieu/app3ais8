function data = load_file(subject, file, fileNumber)
% Load a sample file
% Input :
%   subject : Name of the subject
%   file : Name of the file
%   fileNumber : Number of the try
% Output :
%   data : Loaded data

    path = sprintf('%s/%s/%s_%s.dat', subject, file, file, fileNumber);
    fid = fopen(path,'r','b');  
    data = fread(fid,[6,inf],'single')';   % Lecture du fichier binaire
    fclose(fid);