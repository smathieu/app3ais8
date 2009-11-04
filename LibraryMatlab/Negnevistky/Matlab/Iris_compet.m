% =======================
% Filename: Iris_compet.m
% =======================

echo off

disp(' ===============================================')
disp(' Iris plant classification: competitive learning')
disp(' ===============================================')

disp(' ============================================================================')
disp(' Reference: Negnevitsky, M., "Artificial Intelligence: A Guide to Intelligent')  
disp('            Systems", 2nd edn. Addison Wesley, Harlow, England, 2005.        ')
disp('            Sec. 9.4 Will a neural network work for my problem?              ')
disp(' ============================================================================')

disp(' ======================================================================================')
disp(' Problem: The Iris plant data set contains 3 classes, and each class is represented    ')
disp('          by 50 plants. A plant is characterised by its sepal length, sepal width,     ')
disp('          petal length and petal width. A single-layer competitive network is required ') 
disp('          to classify Iris plants.                                                     ') 
disp(' ======================================================================================')

[iris_data] = Iris_data;
iris_data = (iris_data(:,[1:4]))';

% Massaged values for the Iris plant data set

for n=1:4;
    iris_inputs(n,:)=(iris_data(n,:)-min(iris_data(n,:)))/...
        (max(iris_data(n,:)-min(iris_data(n,:))));
end

iris_target1 = ['Iris-setosa    ']; 
iris_target2 = ['Iris-versicolor'];
iris_target3 = ['Iris-verginica '];

for n=1:(50-1)
   iris_target1=[iris_target1; iris_target1(1,:)];
   iris_target2=[iris_target2; iris_target2(1,:)];
   iris_target3=[iris_target3; iris_target3(1,:)];
end

iris_targets = [iris_target1; iris_target2; iris_target3];

disp(' ')
disp('Hit any key to randomly select input vectors to be used in training.') 
disp(' ')
pause

p=[]; t=[]; test_p=[]; test_t=[];

for n=1:150
   if rand(1)>1/3
      p=[p iris_inputs(:,n)];
      t=[t; iris_targets(n,:)];
   else
      test_p=[test_p iris_inputs(:,n)];
      test_t=[test_t; iris_targets(n,:)];
   end
end

[m n]=size(test_p);

disp(' ')
fprintf(1,' The training data set contains %.0f elements.\n',(150-n));
fprintf(1,' The test data set contains %.0f elements.\n',n);
disp(' ')

disp(' ')
disp('Hit any key to visualise the training data.') 
disp(' ')
pause

figure;
set(figure(1),'position',[5 208 382 320]);
plot3(p(1,:),p(2,:),p(3,:),'r.','markersize',10)
xlabel('Sepal length');
ylabel('Sepal width');
zlabel('Petal length');
title('Input data for the Iris plant classification problem') 
set(gca,'box','on');
hold on;

figure;
set(figure(2),'position',[394 208 382 320]);
plot3(p(4,:),p(3,:),p(1,:),'r.','markersize',10)
xlabel('Petal width');
ylabel('Petal length');
zlabel('Sepal length');
title('Input data for the Iris plant classification problem') 
set(gca,'box','on');
hold on;

echo on

% Hit any key to create and initialise a single-layer competitive network 
% with four input and three competitive neurons.
pause

net=newc(minmax(iris_inputs),3,0.001);
net=init(net);

% Hit any key to train the competitive network. 
pause

net.trainParam.epochs=5;  % Number of epochs between showing the progress
num=20;                   % Maximum number of epochs = num * net.trainParam.epochs

echo off

ww=0.5; D=[];

for i=1:num
   hold on;
   net=train(net,p);
   w=net.IW{1};
   figure(1);
   delete(findobj(gcf,'color',[0 0 1]));
   plot3(w(:,1),w(:,2),w(:,3),'.b','markersize',25);
   figure(2);
   delete(findobj(gcf,'color',[0 0 1]));
   plot3(w(:,4),w(:,3),w(:,1),'.b','markersize',25);
   hold off;
   pause(0.5)
   D=[D; sqrt(sum((w-ww).^2))];
   ww=w;
end

echo off

disp(' ')
disp(' Hit any key to plot the minimum-distance Euclidean criterion.') 
disp(' ')
pause 

e=net.trainParam.epochs:net.trainParam.epochs:num*net.trainParam.epochs;
Dsum=D(:,1)+D(:,2)+D(:,3)+D(:,4);
figure(3);
plot(e,D(:,1),e,D(:,2),e,D(:,3),e,D(:,4),e,Dsum);
title('Learning curve of the competitive network for Iris classification')
xlabel('Epoch');
ylabel('Euclidean distance');

disp(' ')
disp(' Hit any key to identify outputs that correspond to Iris-setosa, Iris-versicolor and') 
disp(' Iris-verginica, respectively.')
disp(' ')
pause 

for i=1:(150-n)
   if t(i,:)==['Iris-setosa    ']
      a=sim(net,p(:,i)); a=find(a);
      setosa(i)=a;  
   elseif t(i,:)==['Iris-versicolor']
      a=sim(net,p(:,i)); a=find(a);
      versicolor(i)=a;
   else
      a=sim(net,p(:,i)); a=find(a);
      verginica(i)=a;    
   end
end

setosa=median(setosa(setosa>0));
versicolor=median(versicolor(versicolor>0));
verginica=median(verginica(verginica>0));

fprintf(1,' Iris-setosa is represented by output:      %.0f \n',setosa);
fprintf(1,' Iris-versicolor is represented by output:  %.0f \n',versicolor);
fprintf(1,' Iris-verginica is represented by output:   %.0f \n',verginica);

disp(' ')
disp(' Hit any key to test the network using the test data set.')
disp(' ')
pause 

n_setosa=0; n_versicolor=0; n_verginica=0;
error_setosa=0; error_versicolor=0; error_verginica=0; error=0;

fprintf(' Sepal length  Sepal width  Petal length  Petal width  Desired output   Actual output  Error\n');

for i=1:n
   fprintf('     %.1f           %.1f          %.1f           %.1f',test_p(1,i),test_p(2,i),test_p(3,i),test_p(4,i));
   a=compet(sim(net,test_p(:,i))); a=find(a);
   if test_t(i,:)==['Iris-setosa    ']
      b=setosa;
      n_setosa=n_setosa+1;
      fprintf('      Iris-setosa            ');
      if abs(a-b)>0
         error_setosa=error_setosa+1;
         fprintf('%.0f        Yes\n',a);
      else
         fprintf('%.0f        No\n',a);
      end
   elseif test_t(i,:)==['Iris-versicolor']
      b=versicolor; 
      n_versicolor=n_versicolor+1;
      fprintf('      Iris-versicolor        ');
      if abs(a-b)>0
         error_versicolor=error_versicolor+1;
         fprintf('%.0f        Yes\n',a);
      else
         fprintf('%.0f        No\n',a);
      end
   else
      b=verginica;
      n_verginica=n_verginica+1;
      fprintf('      Iris-verginica         ');
      if abs(a-b)>0
         error_verginica=error_verginica+1;
         fprintf('%.0f        Yes\n',a);
      else
         fprintf('%.0f        No\n',a);
      end
   end
end

error=(error_setosa+error_versicolor+error_verginica)/n*100;

error_setosa=error_setosa/n_setosa*100;
error_versicolor=error_versicolor/n_versicolor*100;
error_verginica=error_verginica/n_verginica*100;

fprintf(1,' \n')
fprintf(1,' Iris-setosa recognition error:      %.2f \n',error_setosa);
fprintf(1,' Iris-versicolor recognition error:  %.2f \n',error_versicolor);
fprintf(1,' Iris-verginica recognition error:   %.2f \n',error_verginica);
fprintf(1,' \n')
fprintf(1,' Total Iris plant recognition error: %.2f \n',error);
fprintf(1,' \n')

disp('end of Iris_compet.m')