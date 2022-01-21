function f=CostFunction(par) ;

% fonction a minimiser d'ordre 2

x=abs(par(1)) ;
y=abs(par(2)) ;

a=20;
b=1;

f = - cos(a*(x)).*exp(-b*x) .* cos(a*(y)).*exp(-b*y) ;



