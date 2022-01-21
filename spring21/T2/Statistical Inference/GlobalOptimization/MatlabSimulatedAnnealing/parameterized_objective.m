function y = parameterized_objective(x,p1,p2,p3)
%PARAMETERIZED_OBJECTIVE Objective function for PATTERNSEARCH solver

%   Copyright 2004 The MathWorks, Inc.
  
x1 = x(1);
x2 = x(2);
y = (p1-p2.*x1.^2+x1.^4./3).*x1.^2+x1.*x2+(-p3+p3.*x2.^2).*x2.^2;
