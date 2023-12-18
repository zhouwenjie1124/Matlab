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

%% FF Network
%Change the y data to tonndata
T = tonndata(y_output,true,false);

% Choose a Training Function
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% Create a Nonlinear Autoregressive Network
feedbackDelays = 1:2;
hiddenLayerSize = 30;
FF_net = narnet(feedbackDelays,hiddenLayerSize,'open',trainFcn); 

% Prepare the Data for Training and Simulation
[x,xi,ai,ty] = preparets(FF_net,{},{},T);

% Setup Division of Data for Training, Validation, Testing 
FF_net.divideParam.trainRatio = 70/100;
FF_net.divideParam.valRatio = 15/100;
FF_net.divideParam.testRatio = 15/100;

% Setup training parameters
FF_net.trainParam.max_fail = 5; 
FF_net.trainParam.goal = 0.001;  
FF_net.trainParam.min_grad = 1e-5;  

% Train and test the Network
[FF_net,tr] = train(FF_net,x,ty,xi,ai); %tr is trainning log
y_F = FF_net(x,xi,ai);

% compute the MSE
y_F = cell2mat(y_F);
ty = cell2mat(ty);
rmse_FF = rmse(ty,y_F);

% View the Network
view(FF_net)
fig1 = figure('Name', 'NAR Network');
plot(t(3:500),ty, 'o-');
hold on;
plot(t(3:500),y_F, 'rd');
title("NAR network")
xlabel('t')
ylabel ('y')
legend('target y', 'predict y');
grid on

%% RBF Network
% build the network 1
[net1,tr1] = newrb(y_input,y_output,0.0,1,30,30);
y1 = sim(net1,y_input);
rmse_RBF30 = rmse(y_output,y1);

% build the network 2
[net2,tr2] = newrb(y_input,y_output,0.0,1,60,60);
y2 = sim(net2,y_input);
rmse_RBF60 = rmse(y_output,y2);

% build the network 3
[net3,tr3] = newrb(y_input,y_output,0.0,1,90,90);
y3 = sim(net3,y_input);
rmse_RBF90 = rmse(y_output,y3);

% View the network
view(net1)
fig2 = figure('Name', 'RBF Network');
plot(t,y_output, 'o-');
hold on;
plot(t,y1, 'rd');
title("RBF neural network")
xlabel('t')
ylabel ('y')
legend('target y', 'predict y');
grid on

%% comparison
% display in figure
fig3 = figure('Name', 'FF & RBF Network Comparison');
hold on;

% RBF_Network
num_neurons = [30, 60, 90];
rmse_values = [rmse_RBF30, rmse_RBF60, rmse_RBF90];
plot(num_neurons, rmse_values, 'o-');

% FF_Network
x_FF = [num_neurons(1), num_neurons(end)];  
y_FF = [rmse_FF, rmse_FF];  
plot(x_FF, y_FF, 'r');  

% Label
xlabel('Number of RBF Neurons');
ylabel('Root Mean Squared Error');
title('Comparison of RMSE between FF and RBF Networks');
legend('RBF Network', 'FF Network');


