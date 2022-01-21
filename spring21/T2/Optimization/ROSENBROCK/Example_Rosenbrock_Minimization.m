%-------------------------------
% Multivariate optimization
% Example of the Rosenbrock function
%-------------------------------


clear all; % clear variables in workspace
close all; % close all figures
clc;  % clear Matlab Command

%--------------------------------------
% Plotting the function
%--------------------------------------
x=-2:.1:2;
y=-2:.1:3;
[xx,yy]=meshgrid(x,y); % Defintion of the points, with all possible combination (x,y)
zz=(1-xx).^2+100*(yy-xx.^2).^2;  

figure(1);
surf(xx,yy,zz);  xlabel('x'); ylabel('y'); % plot of the function, in 3D. 

figure(2);
levels = [0:2:10, 15:20:100];
contour(xx,yy,zz,levels,'ShowText','on'); grid; % plot of the levels sets
% contour(xx,yy,zz); grid; % plot of the levels sets. Simplest Matlab
% command. 

figure(3);
levels = [0:0.1:1];
contour(xx,yy,zz,levels,'ShowText','off'); % zoom on the level sets


%--------------------------------------
% Minimization of the function
%--------------------------------------

% definition of the objective function, Theta=(x,y).
% Two possibilitiés : 
% ---Possibility 1 : inline definition  Cost_Rosenbrock = @(Theta)((1 - Theta(1))^2 + 100*(Theta(2) - Theta(1)^2)^2);
% ---Possibiliy 2 (the best one in general): defined in a file, here named
% Cost_Rosenbrock.m


% Gradient-free methods : Lender & MEad
%------------------------

Theta_initial=[0;0]; % Initial point,------------- TRY  [0;0]; [1;1] and [5;5];
%options of optimization
options=optimset('fminsearch');
options=optimset(options, 'Display', 'iter', 'MaxIter', 100, 'TolFun', 1e-5, 'TolX', 1e-3); % CHANGE maximal number of iteration MaxIter
% optimization
Theta_opt = fminsearch(@Cost_Rosenbrock,Theta_initial, options );

% Verification: restart from the optimal solution determined by the
% algorithm. 
Theta_opt = fminsearch(@Cost_Rosenbrock,Theta_opt, options );


% Gradient-based methods
%------------------------


Theta_initial=[0;0]; % Initial point,------------- TRY  [0;0]; [1;1] and [5;5];
%options of optimization
options=optimset('fminunc'); % or use optimoptions('fminunc') instead, and use the correspondig fields.

options=optimset(options, 'Display', 'iter', 'MaxIter', 100, 'TolFun', 1e-5, 'TolX', 1e-3); % CHANGE parameters
tic
options.Algorithm = 'quasi-newton'; % to choose quasi-newton method. 
options.HessUpdate = 'bfgs';  % Try also 'DFP', 'steepdesc' for steepest descent
options.GradObj = 'off'; % 'on' if the gradient is provided by the user. In this cas to be given in the file of the objective function. 

% optimization
Theta_opt = fminunc(@Cost_Rosenbrock,Theta_initial, options );
toc
% Verification: restart from the optimal solution determined by the
% algorithm. 
Theta_opt = fminunc(@Cost_Rosenbrock,Theta_opt, options );

