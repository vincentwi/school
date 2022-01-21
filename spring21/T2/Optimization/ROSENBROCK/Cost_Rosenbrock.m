function [J, Nabla_J]=Cost_Rosenbrock(Theta)

J=(1 - Theta(1))^2 + 100*(Theta(2) - Theta(1)^2)^2;

Nabla_J =[]; 

% If you don't want to provide the gradient, put : Nabla_J =[]; otherwise,
% you can do as follows.


% Be careful, if you specify the gradient as below, avoid extra spaces
% in the equations. e.g. (1-Theta(1)) and not (1 - Theta(1)). Can lead to
% Matlab problem depending on your Matlab version.
Nabla_J=[-2*(1-Theta(1))-400*Theta(1)*(Theta(2)-Theta(1)^2)
         200*((Theta(2)-Theta(1)^2))];

%      %%------- possibility 2 . program it like in C, C++ or any classical
%      %%programming language.
%      
%      Nabla_J=zeros(2,1);
%      Nabla_J(1)= -2*(1-Theta(1))-400*Theta(1)*(Theta(2)-Theta(1)^2);
%      Nabla_J(2)=  200*((Theta(2)-Theta(1)^2));