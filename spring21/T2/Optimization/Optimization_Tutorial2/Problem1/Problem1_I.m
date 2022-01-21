%-------------------------------
% -------------Tutorial 2-------
% Problem 1 
%-------------------------------
close all
clear all;
% Data generation 
N = 100 ;
[t,y] = generate_data(N) ;
plot(t,y,'r*'); grid;
drawnow

% Solving
T1=0.1 ; T2=0.2; T3=0.3;

Param_estimated =  ; % TO BE COMPLETED

% trace du modele
t_trace = [0:0.01:1];
y_trace = Param_estimated(1)*exp(-t_trace/T1)+Param_estimated(2)*exp(-t_trace/T2)+Param_estimated(3)*exp(-t_trace/T3);

hold on
plot(t_trace,y_trace)
xlabel('time'); ylabel('output y')


