function data = load_file(subject, file, fileNumber)
    path = sprintf('%s/%s/%s_%s.dat', subject, file, file, fileNumber);
    fid = fopen(path,'r','b');  
    data = fread(fid,[6,inf],'single')';   % Lecture du fichier binaire
    fclose(fid);