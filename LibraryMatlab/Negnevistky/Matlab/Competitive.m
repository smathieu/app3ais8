% =======================
% Filename: Competitive.m
% =======================

echo on;

% ====================
% Competitive learning
% ====================

% ============================================================================
% Reference: Negnevitsky, M., "Artificial Intelligence: A Guide to Intelligent  
%            Systems", 2nd edn. Addison Wesley, Harlow, England, 2005.
%            Sec. 6.8.2 Competitive learning
% ============================================================================

% =========================================================================
% Problem: A single-layer competitive network is required to classify a set
%          of two-element input vectors into four natural classes.
% =========================================================================


% Hit any key to create 80 data points randomly distributed into 4 clusters.
pause

x=[0 1; 0 1;];   % Rx2 matrix of cluster bounds
c=4;             % Number of clusters
n=20;            % Number of data points in each cluster
d=0.05;          % Standard deviation of clusters

[r,q]=size(x);
minp=min(x')';
maxp=max(x')';
rand('seed',1279);
p=rand(r,c).*((maxp-minp)*ones(1,c))+(minp*ones(1,c));
t=c*n;
p=nncopy(p,1,n)+randn(r,t)*d;
plot(p(1,:),p(2,:),'r.');
title('Input vectors');
xlabel('p(1)');
ylabel('p(2)');
hold on;

% Hit any key to create and initialise a single-layer competitive network 
% with two input and four competitive neurons.
pause

net=newc([0 1;0 1],c,.1);
net=init(net);
w=net.IW{1};
plot(w(:,1),w(:,2),'.b','markersize',25);
title('Simulation results for competitive learning: 0 epochs');
xlabel('p(1), w(1)');
ylabel('p(2), w(2)');
hold off;

% Hit any key to train the competitive network. 
pause

net.trainParam.epochs=1;  % Number of epochs between showing the progress

for i=1:5
   hold on;
   net=train(net,p);
   w=net.IW{1};
   delete(findobj(gcf,'color',[0 0 1]));
   plot(w(:,1),w(:,2),'.b','markersize',25);
   tstring = sprintf('Simulation results for competitive learning: %g',(net.trainParam.epochs*i));
   tstring = [tstring sprintf(' epochs')]; 
   title(tstring)
   hold off;
   pause(0.5)
end

for i=1:c;
   text(w(i,1)+0.02,w(i,2),sprintf('Class %g',i));
end

% Hit any key to apply the competitive network for the classification of a randomly
% generated 2-element input vector. The vector is identified by the green marker.

% The output denoted by "a" indicates which competitive neuron is responding, and
% thereby determines the class to which the input belongs.
pause

for i=1:3
   num=round(c*n*rand(1));
   probe=[p(1,num);p(2,num)]+randn(1)*d;
   hold on;
   plot(probe(1,1),probe(2,1),'.g','markersize',25);
   a=sim(net,probe);
   a=find(a)
   text(probe(1,1)+0.02,probe(2,1),sprintf('Class %g',(a)));
   hold off
   % Hit any key to continue.
   if i<3
      pause
   end
end

echo off
disp('end of Competitive.m')