%% Custom Data Type Optimization Using the Genetic Algorithm
% This example shows how to use the genetic algorithm to minimize a
% function using a custom data type. The genetic algorithm is customized to
% solve the traveling salesman problem.

%   Copyright 2004-2015 The MathWorks, Inc.
 
%% Traveling Salesman Problem
% The traveling salesman problem is an optimization problem where there is
% a finite number of cities, and the cost of travel between each city is
% known. The goal is to find an ordered set of all the cities for the
% salesman to visit such that the cost is minimized. To solve the traveling
% salesman problem, we need a list of city locations and distances, or
% cost, between each of them.

%%
% Our salesman is visiting cities in the United States. The file
% |usborder.mat| contains a map of the United States in the variables |x|
% and |y|, and a geometrically simplified version of the same map in the
% variables |xx| and |yy|.
load('usborder.mat','x','y','xx','yy');
plot(x,y,'Color','red'); hold on;

%%
% We will generate random locations of cities inside the border of the
% United States. We can use the |inpolygon| function to make sure that all
% the cities are inside or very close to the US boundary.
cities = 40;
locations = zeros(cities,2);
n = 1;
while (n <= cities)
    xp = rand*1.5;
    yp = rand;
    if inpolygon(xp,yp,xx,yy)
        locations(n,1) = xp;
        locations(n,2) = yp;
        n = n+1;
    end
end
plot(locations(:,1),locations(:,2),'bo');

%%
% Blue circles represent the locations of the cities where the salesman
% needs to travel and deliver or pickup goods. Given the list of city
% locations, we can calculate the distance matrix for all the cities.
distances = zeros(cities);
for count1=1:cities,
    for count2=1:count1,
        x1 = locations(count1,1);
        y1 = locations(count1,2);
        x2 = locations(count2,1);
        y2 = locations(count2,2);
        distances(count1,count2)=sqrt((x1-x2)^2+(y1-y2)^2);
        distances(count2,count1)=distances(count1,count2);
    end;
end;

%% Customizing the Genetic Algorithm for a Custom Data Type
% By default, the genetic algorithm solver solves optimization problems
% based on double and binary string data types. The functions for creation,
% crossover, and mutation assume the population is a matrix of type double,
% or logical in the case of binary strings. The genetic algorithm solver
% can also work on optimization problems involving arbitrary data types.
% You can use any data structure you like for your population. For example,
% a custom data type can be specified using a MATLAB(R) cell array. In order
% to use |ga| with a population of type cell array you must provide a
% creation function, a crossover function, and a mutation function that
% will work on your data type, e.g., a cell array.

%% Required Functions for the Traveling Salesman Problem
% This section shows how to create and register the three required
% functions. An individual in the population for the traveling salesman
% problem is an ordered set, and so the population can easily be
% represented using a cell array. The custom creation function for the
% traveling salesman problem will create a cell array, say |P|, where each
% element represents an ordered set of cities as a permutation vector. That
% is, the salesman will travel in the order specified in |P{i}|. The creation
% function will return a cell array of size |PopulationSize|.
type create_permutations.m

%%
% The custom crossover function takes a cell array, the population, and
% returns a cell array, the children that result from the crossover.
type crossover_permutation.m

%%
% The custom mutation function takes an individual, which is an ordered set
% of cities, and returns a mutated ordered set.
type mutate_permutation.m

%%
% We also need a fitness function for the traveling salesman problem. The
% fitness of an individual is the total distance traveled for an ordered
% set of cities. The fitness function also needs the distance matrix to
% calculate the total distance.
type traveling_salesman_fitness.m

%%
% |ga| will call our fitness function with just one argument |x|, but our
% fitness function has two arguments: |x|, |distances|. We can use an
% anonymous function to capture the values of the additional argument, the
% distances matrix. We create a function handle |FitnessFcn| to an
% anonymous function that takes one input |x|, but calls
% |traveling_salesman_fitness| with |x|, and distances. The variable,
% distances has a value when the function handle |FitnessFcn| is created,
% so these values are captured by the anonymous function.
%distances defined earlier
FitnessFcn = @(x) traveling_salesman_fitness(x,distances);

%%
% We can add a custom plot function to plot the location of the cities and
% the current best route. A red circle represents a city and the blue
% lines represent a valid path between two cities.
type traveling_salesman_plot.m

%%
% Once again we will use an anonymous function to create a function handle
% to an anonymous function which calls |traveling_salesman_plot| with the
% additional argument |locations|.
%locations defined earlier
my_plot = @(options,state,flag) traveling_salesman_plot(options, ...
    state,flag,locations);

%% Genetic Algorithm Options Setup
% First, we will create an options container to indicate a custom data type
% and the population range.
options = optimoptions(@ga, 'PopulationType', 'custom','InitialPopulationRange', ...
                            [1;cities]);

%%
% We choose the custom creation, crossover, mutation, and plot functions
% that we have created, as well as setting some stopping conditions.
options = optimoptions(options,'CreationFcn',@create_permutations, ...
                        'CrossoverFcn',@crossover_permutation, ...
                        'MutationFcn',@mutate_permutation, ...
                        'PlotFcn', my_plot, ...
                        'MaxGenerations',500,'PopulationSize',60, ...
                        'MaxStallGenerations',200,'UseVectorized',true);
%%
% Finally, we call the genetic algorithm with our problem information.

numberOfVariables = cities;
[x,fval,reason,output] = ...
    ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options)

%%
% The plot shows the location of the cities in blue circles as well as the
% path found by the genetic algorithm that the salesman will travel. The
% salesman can  start at either end of the route and at the end, return to
% the starting city to get back home.
