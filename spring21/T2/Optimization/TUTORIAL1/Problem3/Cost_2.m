function val=Cost_2(theta)
% Function 
% Input :  Theta, of dimension=7.
% Output : the value of the cost function

theta1=theta-[10,10,10,10,10,10,10]';

theta2=[1     1     1     0     0     0     0
        0     0     1     0     0     0     0
        0     0     0     1     1     0     0
        0     0     0     0     1     1     1]*theta1;
c=1;
val=norm(theta2)+ c*norm(theta);