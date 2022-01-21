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

Case = 1;

N= 5; % Number of optimizations to solve
for j=1:N
    Theta_initial=1000*randn(3,1); % Initial point - TRY randn, 10*randn , 100*randn
Theta_opt = fminunc(@(x) Cost(x, Case),Theta_initial ); %optimal solution
OptimalCost = Cost(Theta_opt, Case); % optimal cost
AllSolutions=[AllSolutions Theta_opt];
AllCost=[AllCost OptimalCost];
end

AllSolutions
AllCost





