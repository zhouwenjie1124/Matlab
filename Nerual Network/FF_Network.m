%% clear all
clc 
clear

%%  initialize DataSet
% Generate data y
t = 1:500;
y = zeros(size(t));
y(1) = 0.1;
y(2) = 0.2;
y_data = zeros(length(t),3);
for i = 3:length(t)
    y(i) = (0.3 - 0.6 * exp(-y(i-1)^2 * (t(i-1) - 1))) * y(i-1) - ...
           (0.8 + 0.9 * exp(-y(i-1)^2 * (t(i-1) - 1))) * y(i-2) + ...
           0.3 * sin(pi * y(i-1));
    y_data(i,:) = [y(i), y(i-1), y(i-2)];
end
y_input = y_data(:,2:3)';
y_output = y_data(:,1)';

%% Bulid the Network
%Change the y data to tonndata
T = tonndata(y_output,true,false);%tonndata 是 MATLAB 中的一个函数，用于将数据转换为适合于时间序列预测和神经网络训练的格式

% Choose a Training Function
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% Create a Nonlinear Autoregressive Network
feedbackDelays = 1:2;
hiddenLayerSize = 30;
net = narnet(feedbackDelays,hiddenLayerSize,'open',trainFcn); %build a feedforward Nonlinear AutoRegressive Network with 30 hidden node

% Prepare the Data for Training and Simulation
[x,xi,ai,ty] = preparets(net,{},{},T); %ty是神经网络预测的输出目标数据

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.trainParam.max_fail = 5;  % 在验证集上连续5次训练失败后停止训练
net.trainParam.goal = 0.001;  % 期望的 MSE 值为 0.01
net.trainParam.min_grad = 1e-5;  % 梯度的最小值为 1e-5

%% Train and Test the Network
% Train the Network
[net,tr] = train(net,x,ty,xi,ai); %tr is trainning log

% Test the Network
ty_test = net.Y(net.inputs);
y_test = sim(net,y_test);

y_test=cell2mat(y_test);
ty_test=cell2mat(ty_test);


% 查看网络的性能
rmse = rmse(ty_test,y_test);% compute the error between the object and train value

%performance = perform(net,ty,y);% 计算神经网络的性能指标(MSE)
fprintf('RMSE for Network: %.4f\n', rmse);

% View the Network
view(net)




