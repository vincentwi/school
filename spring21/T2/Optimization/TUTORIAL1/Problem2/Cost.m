function [J, Nabla_J]=Cost(Theta)
% Cost function

J=(Theta(1)-5)^2+(Theta(2)-1)^2 + Theta(1)*Theta(2);
Nabla_J =[];

