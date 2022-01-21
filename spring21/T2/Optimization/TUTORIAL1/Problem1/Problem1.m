%-------------------------------
% 1D-optimization
% Example of the course
%-------------------------------

clear all; % clear variables in workspace
close all; % close all figures
clc;  % clear Matlab Command


%--------------------------------------
% Plotting the function
%--------------------------------------

x=[-10:0.1:5]'; % definition of the points
f=x.^2+exp(x); % calculation of the objective function

plot(x,f); grid, xlabel('x'); ylabel('criterion'); % plot

%--------------------------------------
% Numerical optimization
%--------------------------------------

% Gradient-free methods
%------------------------
        fun = @(x) x^2-exp(x);
        options=optimset('fminsearch'); % Algorithm = Golden-search + Parabolic interpoltation. 
        options=optimset(options, 'Display', 'iter');
        options = optimset(options, 'MaxIter', 40, 'TolX', 0.01, 'TolFun', 0.001);

        % all the interval
        xopt=fminsearch(fun, -10, options);

     

