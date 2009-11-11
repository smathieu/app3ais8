function display_result(falls_errors, total_falls, non_falls_errors, total_non_falls)
    f_falls_count = total_falls - falls_errors;
    f_non_falls_count = falls_errors;
    fprintf('F  : Falls : %d/%d => %d\n', f_falls_count, total_falls, round(f_falls_count/total_falls*100))
    fprintf('F  : Non falls : %d/%d => %d\n', f_non_falls_count, total_falls, round(f_non_falls_count/total_falls*100))
    
    nf_falls_count = non_falls_errors;
    nf_non_falls_count = total_non_falls - non_falls_errors;
    fprintf('NF : Falls : %d/%d => %d\n', nf_falls_count, total_non_falls, round(nf_falls_count/total_non_falls*100))
    fprintf('NF : Non falls : %d/%d => %d\n', nf_non_falls_count, total_non_falls, round(nf_non_falls_count/total_non_falls*100))
    
    moy = (round(f_falls_count/total_falls*100) + round(nf_non_falls_count/total_non_falls*100))/2