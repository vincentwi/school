%------------------------------------
%  Examples of the Knapsack problem
%------------------------------------

% Defining Data
%---------------
n=6; % number of items
W= 12;% total weight 
u = [20 16 11 9 7 1]; % utilities
w=[9 8 6 5 4 1] ;% weight of each item
% IMPORTANT REMARK : it is an integer LP problem. So, linprog can be used to solve it.  

% By relaxation 
xopt=linprog(-u, w, W, [],[],zeros(6,1), []);
u*xopt % Ideal real solution
u*round(xopt) % interger solution

% By exact optimization using Branck & cut
% x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,x0,options)
xopt2=intlinprog(-u, [1:n], w, W, [],[],zeros(6,1), ones(6,1));
u*xopt2
