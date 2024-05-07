
% sigma_norm
z = norm(A, sigma)



% 定义x的取值范围
x = 0:0.1:10;

% 定义参数
qi = 2;
qj = 3;

% 计算对应的y值
y = a * x + b;

% 绘制图像
plot(x, y)

% 添加标题和坐标标签
title('Graph of y = ax + b')
xlabel('x')
ylabel('y')