%--------------------------------------------------------
% Global optimization
% Example of minimizing Goldstein Price function
%--------------------------------------------------------

% plot
x=[-5:0.1:5];
y=[-5:0.1:5];
[xx,yy]=meshgrid(x,y);

zz=zeros(length(xx),length(yy));  
for k=1:length(xx)
    for j=1:length(yy)
        zz(k,j)=goldstein_price([xx(k,j);yy(k,j)]);
 end
    
end

figure(1);
surf(xx,yy,zz);  xlabel('x'); ylabel('y'); % plot of the function, in 3D. 


% Initialization
x0=[-5; 5];

% Quasi-newton method
xopt_BFGS=fminunc(@goldstein_price,x0)
goldstein_price(xopt_BFGS)

% Simplex Nelder&Mead
xopt_NM=fminsearch(@goldstein_price,x0)
goldstein_price(xopt_NM)


% Pattern search
xopt_PS=patternsearch(@goldstein_price,x0)
goldstein_price(xopt_PS)

% Simulated annealing
xopt_SA=simulannealbnd(@goldstein_price,x0)
goldstein_price(xopt_SA)

% Genetic algorithm
xopt_GA=ga(@goldstein_price,length(x0))
goldstein_price(xopt_GA)

% PSO
xopt_PSO=particleswarm(@goldstein_price,length(x0))
goldstein_price(xopt_PSO)
