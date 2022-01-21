%-------------------------------
% Multivariate optimization
% Problem 2
%-------------------------------


clear all; % clear variables in workspace
close all; % close all figures
clc;  % clear Matlab Command

%--------------------------------------
% Minimization of the function
%--------------------------------------

% optimization
AllSolutions=[];
AllCost =[];

N= 5; % Number of optimizations to solve
for j=1:N
    Theta_initial=10*randn(7,1); % Initial point - TRY randn, 10*randn , 100*randn
Theta_opt = fminunc(@Cost_1,Theta_initial ); %optimal solution
OptimalCost = Cost_1(Theta_opt); % optimal cost
AllSolutions=[AllSolutions Theta_opt];
AllCost=[AllCost OptimalCost];
end

AllSolutions
AllCost





