%-------------------------------
% Constrained optimization
% Problem 3
%-------------------------------


clear all; % clear variables in workspace
close all; % close all figures
clc;  % clear Matlab Command

%--------------------------------------
% Minimization of the function
%--------------------------------------
x=[-3:0.05:3];
y=[-3:0.05:3];
[xx,yy]=meshgrid(x,y);

zz=xx.^2+yy.^2;

levels = [0:0.1:3];
contour(xx,yy,zz,levels,'ShowText','on'); % zoom on the level sets
hold on,
plot(xx,-xx+1, '*k');

% Solving with FMINCON
Initialization=[0;0];
A=[];
B=[];

Aeq=[];
Beq=[];
lb=[];
ub=[];
options=optimset('fmincon');
options=optimset(options, 'Display', 'iter', 'MaxIter', 100, 'TolFun', 1e-5, 'TolX', 1e-3, 'TolCon', 0.0001); % CHANGE maximal number of iteration MaxIter

%  [OptimalSolution,fval,exitflag,output,lambda]=fmincon(fun,Initialization,A,b,Aeq,beq,lb,ub,nonlcon,options);
 [OptimalSolution,fval,exitflag,output,lambda]=fmincon(@cost,Initialization,A,B,Aeq,Beq,lb,ub,[], options);
 
 lambda
 Aeq*OptimalSolution-Beq

 




