function [J, Nabla_J]=cost(Theta)
x=Theta(1);
y=Theta(2);
J=(x)^2+y^2;
Nabla_J=[];
