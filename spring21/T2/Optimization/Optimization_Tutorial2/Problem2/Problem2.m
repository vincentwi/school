%-------------------------------
% Potofolio optimization
% Problem 2
%-------------------------------


clear all; % clear variables in workspace
close all; % close all figures
clc;  % clear Matlab Command

Rates=[16.1	15.7	10.1	11.5	10.3
13.3	20.4	11.2	18.5	17.9];

% Caculation of the mean values.
 Mean1 = mean(Rates(1,:));
 Mean2 = mean(Rates(2,:));
 
 % Calculation of the Covariance matrix
 Q= cov(Rates');


 % Modeling the optimization problem
 
 Theta_opt=; % TO BE COMPLETED