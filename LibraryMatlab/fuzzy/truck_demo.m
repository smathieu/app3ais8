% ===========================
% Filename : truck_demo.m
% ===========================

echo on;

% ====================================================================
% Modelisation floue d'une fonction
% ====================================================================


% Hit any key to load the fuzzy system.
pause

% Parametre du systeme flou
a=readfis('truck_demo.fis');

% Hit any key to display the whole system as a block diagram.
pause

figure('name','Block diagram of the fuzzy system');
plotfis(a);

% Hit any key to display fuzzy sets for the linguistic variable "X".
pause

figure('name','X');
plotmf(a,'input',1);

% Hit any key to display fuzzy sets for the linguistic variable "Phi".
pause

figure('name','Phi');
plotmf(a,'input',2);

% Hit any key to display fuzzy sets for the linguistic variable "Rotation".
pause

figure('name','Rotation');
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


% TRUCK_TRAPEZE: based on
% FISMAT: Fuzzy Inference Systems toolbox for MATLAB
% (c) A. Lotfi, University of Queensland (Email: lotfia@s1.elec.uq.oz.au)
% 13-10-93
% The program has been tested on MATLAB version 4.1, Sun workstation.

% Backing a truck to a loading dock is a nonlinear control problem which
% can involve extensive computation time to steer the truck to a 
% prescribed loading zone. The dynamic of truck backer-upper is given 
% in truck.m file. The input of this function are position
% of truck (x,y in yard), azimuth angle (Phi) of truck and the steering
% angle of truck (Theta). The function will return the next state of
% system. 

% The range of variables for simulated truck and controllers are as follows;

X=[0:1:100];       % Horizontal position
Phi=[-90:1:270];   % Orientation
Theta=[-30:1:30];  % Steering angle

pause % Press any key to continue
clc;
% Since we presuppose adequate clearance between the truck and the loading
% dock, state variable Y can be abandoned. Therefore the inputs of 
% controller are X and Phi.

% The control goal is to steer the truck from any initial position to 
% prespecified loading dock with a right azimuth angle (Phi_final=90) and
% coincided rear position. The steering angle Theta is the control action
% which is provided by the designed fuzzy  controller. 
 
% We can select any approximate reasoning methods explained earlier, 
% the method we are going to use here is MAMDANI.
% The initial state of truck must be given for running simulation. We can
% assume;

truck_state_0=[20,20,90]'  %[X_position, Y_position, Azimuth angle Phi]


% The calculated steering angle is a continuous variable in the universe of 
% Theta.  To be more realistic, it needs to be quantize before applying it to 
% truck.

%>> for i=1:100
%>> [fuzzy_decision]=mamdani(A1,trst(1),X,A2,trst(3),Phi,U2,B,1,1);
%>> steer_angle=defzfir(fuzzy_decision,Theta,1);
%>> steer_angle_q=quantize(steer_angle,2);
%>> trst=truck(trst,steer_angle_q);
%>> end

%			Wait Please ........

echo off;
trst=truck_state_0;
state1=[];state2=[];state3=[];sangle1=[];sangle2=[];sangle3=[];

clf;set(gcf,'units','normal','position',[.44 .55 .55 .4])
truck_axes=axes('units','normal','position',[.3 .1 .6 .8]);
truck_plot=plot(0,0);
axis([0 100 0 100]);
set(gca,'xtick',[0 10 20 30 40 50 60 70 80 90 100])
xlabel('X position');ylabel('Y position');title('Etu');

set(truck_plot,'erasemode','none','linestyle','*','color','r')

deci_axes=axes('position',[.03,.1,.2,.2]);
deci_plot=plot(Theta,zeros(size(Theta)),0,0,'r*');
axis([-30 30 0 2]);set(deci_axes,'xtick',[-30 0 30],'ytick',[0 2]);
xlabel('Steering angle');title('Fuzzy Decision')
set(deci_plot,'erasemode','xor')

truck_state_0=[20,20,90]';  %[X_position, Y_position, Azimuth angle Phi]
text(20,20,'Initial Position');
trst=truck_state_0;state=[];

step=1;
while step < 300
	 state1=[state1,trst];
	 [steer_angle]=evalfis([trst(1) trst(3)],a);
	 steer_angle_q=quantize(steer_angle,2);
	 trst=truck(trst,steer_angle_q);
	if trst(2) >= 100
		step=301;	
	end
	set(truck_plot,'xdata',trst(1),'ydata',trst(2));
	drawnow
	 step=step+1;
end

set(truck_plot,'color','y')
truck_state_0=[80,30,120]';  
trst=truck_state_0;state=[];

step=1;
while step < 300
	 state1=[state1,trst];
	 [steer_angle]=evalfis([trst(1) trst(3)],a);
	 steer_angle_q=quantize(steer_angle,2);
	 steer_angle_q=quantize(steer_angle,2);
	 trst=truck(trst,steer_angle_q);
	if trst(2) >= 100
		step=301;	
	end
	set(truck_plot,'xdata',trst(1),'ydata',trst(2));
	drawnow
	 step=step+1;
end
 
set(truck_plot,'color','g')
truck_state_0=[60,40,-90]';
trst=truck_state_0;state=[];

step=1;
while step < 300
	 state1=[state1,trst];
	 [steer_angle]=evalfis([trst(1) trst(3)],a);
	 steer_angle_q=quantize(steer_angle,2);
	 steer_angle_q=quantize(steer_angle,2);
	 trst=truck(trst,steer_angle_q);
	if trst(2) >= 100
		step=301;	
	end
	set(truck_plot,'xdata',trst(1),'ydata',trst(2));
	drawnow
	 step=step+1;
end

echo on;





% Hit any key to continue.
pause

echo off
disp('End of truck_demo.m')
