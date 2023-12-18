%  Define Object Function
ObjectiveFunction = @(x) 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;

% Defien the range of fucntion
x1 = linspace(-2, 2, 100);
x2 = linspace(-2, 2, 100);
[X1, X2] = meshgrid(x1, x2);

% compute the function value
Y = zeros(size(X1));
for i = 1:numel(X1)
    Y(i) = ObjectiveFunction([X1(i), X2(i)]);
end

% draw the graphic
figure;
surf(X1, X2, Y);
xlabel('x1');
ylabel('x2');
zlabel('Objective Function');
title('Objective Function Surface');
colorbar;

x0 = [0,0];

[x_min, fval_min] = fminsearch(ObjectiveFunction, x0);