function GeneticAlgorithm
ObjectiveFunction = @simple_fitness; %将目标函数 simple_fitness 分配给变量 ObjectiveFunction
nvars = 2; % Number of variables
LB = [-2 -2]; % Lower bound
UB = [2 2]; % Upper bound
ConstraintFunction = @simple_constraint;
options = gaoptimset('PopulationSize',50,'Generations',100,'Display','iter');
[x,fval] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB,ConstraintFunction,options);
end

function y = simple_fitness(x)
y = 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
end

function [c, ceq] = simple_constraint(x)
c = [];
ceq = [];
end

