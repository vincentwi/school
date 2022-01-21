function [t,y] = generer_donnees(N);

% genere des donnees a ajuster
% avec :
% N : nombre de points generes
% t : leurs abscisses
% y : leurs ordonnees

rand('seed',0)

t=rand(N,1);

a1 = 0.4;
a2 = 0.1;
a3 = 2  ;

T1=0.1;
T2=0.2;
T3=0.3;

y=a1*exp(-t/T1)+a2*exp(-t/T2)+a3*exp(-t/T3) + 0.05*randn(N,1);

