% ===========================
% Filename : function_fuzzy.m
% ===========================

echo on;

% ====================================================================
% Modelisation floue d'une fonction
% ====================================================================


% Hit any key to load the fuzzy system.
pause

a=readfis('function_fuzzy.fis');

% Hit any key to display the whole system as a block diagram.
pause

figure('name','Block diagram of the fuzzy system');
plotfis(a);

% Hit any key to display fuzzy sets for the linguistic variable "x".
pause

figure('name','x');
plotmf(a,'input',1);

% Hit any key to display fuzzy sets for the linguistic variable "y".
pause

figure('name','y');
plotmf(a,'input',2);

% Hit any key to display fuzzy sets for the linguistic variable "z".
pause

figure('name','z');
plotmf(a,'output',1);

% Hit any key to bring up the Rule Editor.
pause

ruleedit(a);

% Hit any key to generate three-dimensional plots for Rule Base.
pause

figure('name','Three-dimensional surface (a)');
gensurf(a,[1 2],1); view([140 37.5]);

% Hit any key to continue.
pause

ruleview(a);

% Hit any key to continue.
pause

% FONCTION A MODELISER
x=[-2:0.2:2];
y=[-2:0.2:2];
z=[-0.5:0.05:0.5];

[xx,yy]=meshgrid(x,y);
zz=xx.*exp(-xx.^2-yy.^2);
cont_surf1=mesh(xx,yy,zz);
xlabel('x');ylabel('y');
zlabel('z');

% Hit any key to continue.
pause

echo off
% MODELE FLOU
for i =1:length(x),
    for j =1:length(y),
        zzf(i,j)=evalfis([xx(i,j) yy(i,j)],a);
    end
end
echo on

% SURFACE D'ERREUR ENTRE LA FONCTION FLOUE ET LA FONCTION ORIGINALE
erre_surf=mesh(xx,yy,zzf-zz);
xlabel('x');ylabel('y');
zlabel('z');

% Moyenne de l'erreur absolue, a minimiser
mean(mean(abs(zzf)))

% Hit any key to continue.
pause

echo off
disp('End of function_fuzzy.m')
