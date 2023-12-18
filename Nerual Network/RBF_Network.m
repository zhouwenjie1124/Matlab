%% clear all
clc 
clear

%% intput, output data 
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
y_input = y_data(:,2:3)';
y_output = y_data(:,1)';

%% Bulid & Test the Network
% build the network 1
%数据划分
trainNum = 500*0.7; 
valNum = 500*0.15;
testNum = 500*0.15;

y_input_train = y_input(1:trainNum);
y_output_train = y_output(1:trainNum);

y_input_val = y_input(trainNum+1:trainNum+valNum);
y_output_val = y_output(trainNum+1:trainNum+valNum);

y_input_test = y_input(trainNum+valNum+1:end);
y_output_test = y_output(trainNum+valNum+1:end);

%建立网络1,训练与验证
[net1,tr1] = newrb(y_input_train,y_output_train,0.0,1,30,30);
%y1_val = sim(net1,y_input_val);
y1_train = sim(net1,y_input_train);
rmse_RBF30_train = rmse(y_output_train,y1_train);

%建立网络2,训练与验证
[net2,tr2] = newrb(y_input_train,y_output_train,0.0,1,60,60);
%y1_val = sim(net1,y_input_val);
y2_train = sim(net2,y_input_train);
rmse_RBF60_train = rmse(y_output_train,y2_train);

%建立网络3,训练与验证
[net3,tr3] = newrb(y_input_train,y_output_train,0.0,1,90,90);
%y1_val = sim(net1,y_input_val);
y3_train = sim(net3,y_input_train);
rmse_RBF90_train = rmse(y_output_train,y3_train);


%% Graph 
%view(net)
