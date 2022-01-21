%-------------------------------
% Global optimization
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




x0=[-10; 10];

% Quasi-newton method
xopt_BFGS=fminunc(@rosenbrock,x0)
rosenbrock(xopt_BFGS)

% Simplex Nelder&Mead
xopt_NM=fminsearch(@rosenbrock,x0)
rosenbrock(xopt_NM)


% Pattern search
xopt_PS=patternsearch(@rosenbrock,x0)
rosenbrock(xopt_PS)

% Simulated annealing
xopt_SA=simulannealbnd(@rosenbrock,x0)
rosenbrock(xopt_SA)

% Genetic algorithm
xopt_GA=ga(@rosenbrock,length(x0))
rosenbrock(xopt_GA)

% PSO
xopt_PSO=particleswarm(@rosenbrock,length(x0))
rosenbrock(xopt_PSO)
