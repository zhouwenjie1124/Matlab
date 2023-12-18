t = 1:500;
y = zeros(size(t));
y(1) = 0.1;
y(2) = 0.2;
y_data = zeros(length(t),3);

for i = 3:length(t)
    y(i) = (0.3 - 0.6 * exp(-y(i-1)^2 * (t(i-1) - 1))) * y(i-1) - ...
           (0.8 + 0.9 * exp(-y(i-1)^2 * (t(i-1) - 1))) * y(i-2) + ...
           0.3 * sin(pi * y(i-1));
    
    % 将每次循环生成的三个值添加到 y_data
    y_data(i,:) = [y(i), y(i-1), y(i-2)];
end

% 绘制三维图像
figure;
plot3(y_data(:, 3), y_data(:, 2), y_data(:, 1), 'LineWidth', 2);

% 添加标签和标题
xlabel('y(i-2)');
ylabel('y(i-1)');
zlabel('y(i)');
title('y Display');