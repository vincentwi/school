%------------------------------------
%  Examples of teh relaxation approach
%------------------------------------

% Example 1
%---------------
% By relaxation 
xopt=linprog(-[10 11], [10 12], 59, [],[],[0; 0], []);

% By exact optimization
% x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,x0,options)
xopt2=intlinprog(-[10 11], [1,2], [10 12], 59, [],[],[0; 0], []);

% Example 1-bis
%----------------
% By relaxation 
xopt=linprog(-[11 10], [10 12], 59, [],[],[0; 0], []);

% By exact optimization
% x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,x0,options)
xopt2=intlinprog(-[11 10], [1,2], [10 12], 59, [],[],[0; 0], []);



% Example 2
%-----------------------
% By relaxation 

xopt=linprog(-[2 3], [10 12], 59, [],[],[0; 0], []);

% By exact optimization
% x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,x0,options)
xopt2=intlinprog(-[2 3], [1,2], [10 12], 59, [],[],[0; 0], []);