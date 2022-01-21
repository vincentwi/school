%-------------------------------
% -------------Tutorial 2-------
% Problem 1 . Question II. 
%-------------------------------
close all
clear all;
% Data generation 
N = 100 ;
[t,y] = generate_data(N) ;
plot(t,y,'r*'); grid;
drawnow

% Solving
a1 = 0.4;
a2 = 0.1;
a3 = 2  ;

LB=1e-3*[1 ;1 ;1];
UB=Inf*[1 ;1 ;1];
x0=[1; 1; 1];
options=optimset('lsqnonlin');
options=optimset(options, 'Display', 'iter');
Param_estimated = lsqnonlin(@(x) Error(x, t,y), x0, LB, UB, options); % COMPLETE ERROR


% trace du modele
t_trace = [0:0.01:1];
y_trace = a1*exp(-t_trace/Param_estimated(1))+a2*exp(-t_trace/Param_estimated(1))+a3*exp(-t_trace/Param_estimated(1));

hold on
plot(t_trace,y_trace)
xlabel('time'); ylabel('output y')


