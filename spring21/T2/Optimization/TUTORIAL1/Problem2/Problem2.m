%-------------------------------
% Multivariate optimization
% Problem 2
%-------------------------------


clear all; % clear variables in workspace
close all; % close all figures
clc;  % clear Matlab Command

%--------------------------------------
% Plotting the function
%--------------------------------------
x=-20:.4:20;
y=-20:.4:20;

% Possibility 1 
[xx,yy]=meshgrid(x,y); % Definition of the points, with all possible combination (x,y)
zz=(xx-5).^2+(yy-1).^2 + xx.*yy;

% Possibility 2
zz=zeros(length(x), length(y));
for j=1:length(x)
    for k=1:length(y)
        zz(j,k)=Cost([x(j),y(k)]);
    end
end


figure(1);
surf(xx,yy,zz);  xlabel('x'); ylabel('y'); % plot of the function, in 3D. 

figure(2);
levels = [0:2:10, 15:20:100];
contour(xx,yy,zz,levels,'ShowText','on'); grid; % plot of the levels sets


%--------------------------------------
% Minimization of the function
%--------------------------------------

Theta_initial=[0;0]; % Initial point,
%options of optimization
options=optimset('fminunc'); % or use optimoptions('fminunc') instead, and use the correspondig fields.

options=optimset(options, 'Display', 'iter', 'MaxIter', 100, 'TolFun', 1e-5, 'TolX', 1e-3); % CHANGE parameters
tic
options.Algorithm = 'quasi-newton'; % to choose quasi-newton method. 
options.HessUpdate = 'bfgs';  % Try also 'DFP', 'steepdesc' for steepest descent
options.GradObj = 'off'; % 'on' if the gradient is provided by the user. In this cas to be given in the file of the objective function. 

% optimization
Theta_opt = fminunc(@Cost,Theta_initial, options );
toc


