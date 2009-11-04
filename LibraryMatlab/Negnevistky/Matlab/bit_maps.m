function [digit1,digit2,digit3,digit4,digit5,digit6,digit7,digit8,digit9,digit0] = bit_maps()

% ==============================
% Bit maps for digit recognition
% ==============================

% ============================================================================
% Reference: Negnevitsky, M., "Artificial Intelligence: A Guide to Intelligent  
%            Systems", 2nd end. Addison Wesley, Harlow, England, 2005.                 
%            Sec. 9.4 Will a neural network work for my problem?              
% ============================================================================

digit1 =  [0 0 1 0 0
           0 1 1 0 0
           1 0 1 0 0
           0 0 1 0 0
           0 0 1 0 0
           0 0 1 0 0
           0 0 1 0 0
           0 0 1 0 0
           0 0 1 0 0 ];
        
digit=digit1;
digit_plot(digit)

digit2 =  [0 1 1 1 0
           1 0 0 0 1
           0 0 0 0 1
           0 0 0 0 1
           0 0 0 1 0
           0 0 1 0 0
           0 1 0 0 0
           1 0 0 0 0
           1 1 1 1 1 ];
        
digit=digit2;
digit_plot(digit)

digit3 =  [0 1 1 1 0 
           1 0 0 0 1 
           0 0 0 0 1 
           0 0 0 0 1 
           0 0 0 1 0 
           0 0 0 0 1 
           0 0 0 0 1 
           1 0 0 0 1 
           0 1 1 1 0 ];
        
digit=digit3;
digit_plot(digit)

digit4 =  [0 0 0 1 0 
           0 0 1 1 0 
           0 0 1 1 0 
           0 1 0 1 0 
           0 1 0 1 0 
           1 0 0 1 0 
           1 1 1 1 1 
           0 0 0 1 0
           0 0 0 1 0 ];
        
digit=digit4;
digit_plot(digit)

digit5 =  [1 1 1 1 1 
           1 0 0 0 0 
           1 0 0 0 0 
           1 1 1 1 0 
           1 0 0 0 1 
           0 0 0 0 1 
           0 0 0 0 1 
           1 0 0 0 1 
           0 1 1 1 0 ];
     
digit=digit5;
digit_plot(digit)

digit6 =  [0 1 1 1 0 
           1 0 0 0 1 
           1 0 0 0 0 
           1 0 0 0 0 
           1 1 1 1 0 
           1 0 0 0 1 
           1 0 0 0 1
           1 0 0 0 1 
           0 1 1 1 0 ];
     
digit=digit6;
digit_plot(digit)

digit7 =  [1 1 1 1 1 
           0 0 0 0 1
           0 0 0 1 0 
           0 0 0 1 0 
           0 0 1 0 0 
           0 0 1 0 0 
           0 1 0 0 0 
           0 1 0 0 0 
           0 1 0 0 0 ];
        
digit=digit7;
digit_plot(digit)

digit8 =  [0 1 1 1 0 
           1 0 0 0 1 
           1 0 0 0 1 
           1 0 0 0 1 
           0 1 1 1 0 
           1 0 0 0 1 
           1 0 0 0 1 
           1 0 0 0 1 
           0 1 1 1 0 ];
        
digit=digit8;
digit_plot(digit)

digit9 =  [0 1 1 1 0 
           1 0 0 0 1 
           1 0 0 0 1 
           1 0 0 0 1 
           0 1 1 1 1 
           0 0 0 0 1 
           0 0 0 0 1 
           1 0 0 0 1 
           0 1 1 1 0 ];
        
digit=digit9;
digit_plot(digit)

digit0 =  [0 1 1 1 0 
           1 0 0 0 1 
           1 0 0 0 1 
           1 0 0 0 1 
           1 0 0 0 1 
           1 0 0 0 1 
           1 0 0 0 1 
           1 0 0 0 1 
           0 1 1 1 0 ];
     
digit=digit0;
digit_plot(digit)

function digit_plot(digit);

[m n]=size(digit);
digit_plot=[digit digit(:,[n])]';
digit_plot=[digit_plot digit_plot(:,[m])]';
pcolor(digit_plot)
colormap(gray)
axis('ij')
axis image
pause(1.0)