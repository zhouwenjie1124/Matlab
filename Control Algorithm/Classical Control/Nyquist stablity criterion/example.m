
% system fucntion
K = 20; % controller gain
controller = K * tf ([1 0.1],[1 0.01]);
sys = tf([0 1],[1 0.4 1]);
H = tf([0 1],[1 5]);

% open loop function
GH = controller * sys * H;

nyquist(GH);
