clear
clc

%% Laplacian Matrix
global L Ll
L = [1  0  0 -1
    -1  1  0  0
     0 -1  1  0
     0  0 -1  1];

Ll= diag([1  1  0  0]);

%% Initial States
Xf = [20 10 40 00];
Xl = 20;

%% Time Parameters
tBegin = 0;
tFinal = 20;
tspan = [tBegin, tFinal];

%% Calculate ODE Function
In = [Xl Xf]';
out = ode23(@ctFun, tspan, In);
t = out.x;
X = out.y;

%% Draw Graphs
plot(t,X(1,:), t,X(2,:), t,X(3,:), t,X(4,:), t,X(5,:), 'linewidth',1.5);
legend('$x_0$','$x_1$','$x_2$','$x_3$','$x_4$', 'Interpreter','latex'); grid on
xlabel('$t(s)$', 'Interpreter','latex');
ylabel('$x$', 'Interpreter','latex');

%% ODE Function
function out = ctFun(~,In)
    global L Ll 
    Xl = In(1);
    Xf = In(2:5);
    
    v_0 = 3;
    dXl = v_0;
    X_Bar = Xf - Xl;
    dX = -(L+Ll) * X_Bar + v_0;
    
    out = [dXl 
           dX];
end
