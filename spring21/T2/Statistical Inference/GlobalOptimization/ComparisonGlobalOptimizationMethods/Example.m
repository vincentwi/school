%-------------------------------
% Global optimization
% Example of the CostFunction function
%-------------------------------


clear all; % clear variables in workspace
close all; % close all figures
clc;  % clear Matlab Command

%--------------------------------------
% Plotting the function
%--------------------------------------
x=-2:.1:2;
y=-2:.1:2;
[xx,yy]=meshgrid(x,y); % Defintion of the points, with all possible combination (x,y)

zz=zeros(length(xx),length(yy));  
for k=1:length(xx)
    for j=1:length(yy)
        zz(k,j)=CostFunction([xx(k,j);yy(k,j)]);
 end
    
end

figure(1);
surf(xx,yy,zz);  xlabel('x'); ylabel('y'); % plot of the function, in 3D. 




x0=[-10; 10];

% Quasi-newton method
xopt_BFGS=fminunc(@CostFunction,x0)
CostFunction(xopt_BFGS)

% Simplex Nelder&Mead
xopt_NM=fminsearch(@CostFunction,x0)
CostFunction(xopt_NM)


% Pattern search
xopt_PS=patternsearch(@CostFunction,x0)
CostFunction(xopt_PS)

% Simulated annealing
xopt_SA=simulannealbnd(@CostFunction,x0)
CostFunction(xopt_SA)

% Genetic algorithm
xopt_GA=ga(@CostFunction,length(x0))
CostFunction(xopt_GA)

% PSO
xopt_PSO=particleswarm(@CostFunction,length(x0))
CostFunction(xopt_PSO)
