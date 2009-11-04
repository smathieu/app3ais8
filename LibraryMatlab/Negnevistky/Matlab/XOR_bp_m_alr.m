% ========================
% Filename: XOR_bp_m_alr.m
% ========================

rand('seed',9315);

echo on;

% =============================================================================
% Back-propagation algorithm: learning with momentum and adaptive learning rate
% =============================================================================

% ============================================================================
% Reference: Negnevitsky, M., "Artificial Intelligence: A Guide to Intelligent  
%            Systems", 2nd edn. Addison Wesley, Harlow, England, 2005.
%            Sec. 6.5 Accelerated learning in multilayer neural networks
% ============================================================================

% =============================================================
% Problem: The three-layer back-propagation network is required  
%          to perform logical operation Exclusive-OR.
% =============================================================

% Hit any key to define four 2-element input vectors denoted by "p". 
pause 

p=[1 0 1 0;1 1 0 0]

% Hit any key to define four 1-element target vectors denoted by "t". 
pause 

t=[0 1 1 0]

% Hit any key to define the network architecture.
pause

s1=2; %Two neurons in the hidden layer
s2=1; %One neuron in the output layer

% Hit any key to create the network and initialise its weights and biases.
pause

net=newff([0 1;0 1],[s1,s2],{'tansig','purelin'},'traingdx');

% Hit any key to set up the frequency of the training progress to be displayed,
% maximum number of epochs, acceptable error, learning rate, and momentum constant. 
pause 

net.trainParam.show=1;      % Number of epochs between showing the progress
net.trainParam.epochs=1000; % Maximum number of epochs
net.trainParam.goal=0.001;  % Performance goal
net.trainParam.lr=0.1;      % Learning rate
net.trainParam.lr_inc=1.05; % Learning rate increase multiplier
net.trainParam.lr_dec=0.7;  % Learning rate decrease multiplier
net.trainParam.mc=0.9;      % Momentum constant

% Hit any key to train the back-propagation network with momentum. 
pause 

[net,tr]=train(net,p,t);

% Hit any key to plot the training errors and learning rates. 
pause 

figure
subplot(2,1,1), plot(tr.epoch,tr.perf)
tstring = sprintf('Training for %g epochs',max(tr.epoch));
title(tstring);
xlabel ('Epoch'); ylabel('Sum-squared error'); 
subplot(2,1,2), plot(tr.epoch,tr.lr)
xlabel ('Epoch'); ylabel('Learning rate');

% Hit any key to plot the input and target vectors, and classification lines.
pause

figure
plotpv(p,t);
linehandle=plotpc(net.IW{1},net.b{1});

% Hit any key to see whether the network has learned the XOR operation.
pause 

p=[1;1]
a=sim(net,p)

% Hit any key to continue.
pause 

p=[0;1]
a=sim(net,p)

% Hit any key to continue.
pause 

p=[1;0]
a=sim(net,p)

% Hit any key to continue.
pause 

p=[0;0]
a=sim(net,p)

echo off
disp('end of XOR_bp_m_alr')

