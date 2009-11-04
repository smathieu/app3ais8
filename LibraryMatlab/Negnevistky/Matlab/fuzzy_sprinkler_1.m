% ==============================
% Filename : fuzzy_sprinkler_1.m
% ==============================

echo on;

% ======================================================
% Water Sprinkler Control System: Mark 1 (9-rule system)
% ======================================================

% ============================================================================
% Reference: Negnevitsky, M., "Artificial Intelligence: A Guide to Intelligent  
%            Systems", 2nd edn. Addison Wesley, Harlow, England, 2005.
%            Sec. 4.7 Building a fuzzy expert system
% ============================================================================

% ==================================================================================
% Problem: The water sprinkler system receives inputs via its sensors and determines 
%          the watering duration. The fuzzy controller uses two inputs: air 
%          temperature, and soil moisture. The system controls the watering duration
%          by turning various valves on and off automatically.
% ==================================================================================

% Hit any key to load the fuzzy system.
pause

a=readfis('sprinkler_1.fis');

% Hit any key to display the whole system as a block diagram.
pause

figure('name','Block diagram of the fuzzy control system');
plotfis(a);

% Hit any key to display fuzzy sets for the linguistic variable "Air temperature".
pause

figure('name','Air temperature, °C');
plotmf(a,'input',1);

% Hit any key to display fuzzy sets for the linguistic variable "Soil moisture".
pause

figure('name','Soil moisture, %');
plotmf(a,'input',2);

% Hit any key to display fuzzy sets for the linguistic variable "Watering duration".
pause

figure('name','Watering duration, minutes');
plotmf(a,'output',1);

% Hit any key to bring up the Rule Editor.
pause

ruleedit(a);

% Hit any key to generate three-dimensional plots for Rule Base.
pause

figure('name','Three-dimensional surface (a)');
gensurf(a,[1 2],1); view([140 37.5]);

% Hit any key to bring up the Rule Viewer.
pause

ruleview(a);

echo off
disp('End of fuzzy_sprinkler_1.m')
