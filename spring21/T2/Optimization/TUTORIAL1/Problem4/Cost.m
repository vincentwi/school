function val=Cost(theta, Case)
% Input :  Theta, of dimension 3.
% Output : the value of objective function. 



if Case==1
x=theta(1);
y=theta(2);
z=theta(3);
val=x^2+0.00001*y^2+z^2;

elseif Case==2
x=theta(1);
y=theta(2)-123456;
z=theta(3);
val=x^2+y^2+z^2;

elseif Case==3
x=theta(1);
y=theta(2)-123456;
z=theta(3);
val=x^2+y^2+0.0001*z^2;

else
    disp('Error, case not specified. ')
end
