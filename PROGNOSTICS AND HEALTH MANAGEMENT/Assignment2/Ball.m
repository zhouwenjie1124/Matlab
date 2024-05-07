%% Load Data
% Ball
load("B014_2_288.mat")
fs12k = 12000;
fs = 12000;
v=70;
%% time domain
i_data_size = size(X288_DE_time,1);
t = 0:1/fs12k:(i_data_size - 1)/fs12k;

Inner_DE = X288_DE_time(:,1);

%% Envelope analysis

% hilbert_transform
hilbert_transform = hilbert(Inner_DE);

% envelope
envelope = abs(hilbert_transform);
FFT = fft(Inner_DE);
L = length(Inner_DE);
frequency = (0:L/2-1)*(fs12k/L); 
fft_signal = abs(FFT);
fft_envelope = abs(fft(envelope));

subplot(2,1,2);
plot(frequency, fft_envelope(1:L/2));
xlabel('Frequency');
ylabel('Amplitude');
xlim([0 500])



%% Discrete wavelet transform
[c,l] = wavedec(Inner_DE,3,'db1');
for k=1:max(size(l)-1)
    subplot(max(size(l)-1),2,2*k-1);
    if k>1
        startIndex = startIndex+l(k-1)-1;
    else
        startIndex = 1;
    end
    tempx = Inner_DE(startIndex:(startIndex+l(k)-1));
    plot(0:1/fs:(length(tempx)-1)/fs,tempx);
    subplot(max(size(l)-1),2,2*k);
    [pEnvInner, fEnvInner, xEnvInner, tEnvInner] = envspectrum(tempx, fs);
    plot(fEnvInner, pEnvInner)
    xlim([0 400]);hold on;
end


wpt = wpdec(Inner_DE, 4, 'db1');


subplot(4,2,1)
stem(t,wpt(1,:),'Marker','none','ShowBaseline','off')
ylabel('mV')
subplot(4,2,2)
stem(t,wpt(2,:),'Marker','none','ShowBaseline','off')
ylabel('mV')
subplot(4,2,3)
stem(t,wpt(3,:),'Marker','none','ShowBaseline','off')
ylabel('mV')
subplot(4,2,4)
stem(t,wpt(4,:),'Marker','none','ShowBaseline','off')
ylabel('mV')
subplot(4,2,5)
stem(t,wpt(5,:),'Marker','none','ShowBaseline','off')
ylabel('mV')
subplot(4,2,6)
stem(t,wpt(6,:),'Marker','none','ShowBaseline','off')
ylabel('mV')
subplot(4,2,7)
stem(t,wpt(7,:),'Marker','none','ShowBaseline','off')
ylabel('mV')
subplot(4,2,8)
stem(t,wpt(8,:),'Marker','none','ShowBaseline','off')
ylabel('mV')

% subplot(4,2,1)
% stem(t,wpt(1,:),'Marker','none','ShowBaseline','off')
% ylabel('mV')
% subplot(4,2,2)
% stem(t,wpt(2,:),'Marker','none','ShowBaseline','off')
% ylabel('mV')
% subplot(4,2,3)
% stem(t,wpt(3,:),'Marker','none','ShowBaseline','off')
% ylabel('mV')
% subplot(4,2,4)
% stem(t,wpt(4,:),'Marker','none','ShowBaseline','off')
% ylabel('mV')
% subplot(4,2,5)
% stem(t,wpt(5,:),'Marker','none','ShowBaseline','off')
% ylabel('mV')
% subplot(4,2,6)
% stem(t,wpt(6,:),'Marker','none','ShowBaseline','off')
% ylabel('mV')
% subplot(4,2,7)
% stem(t,wpt(7,:),'Marker','none','ShowBaseline','off')
% ylabel('mV')
% subplot(4,2,8)
% stem(t,wpt(8,:),'Marker','none','ShowBaseline','off')
% ylabel('mV')
% %%
% [c,l] = wavedec(Inner_DE,4,"db1");
% approx = appcoef(c,l,"db1");
% [cd1,cd2,cd3] = detcoef(c,l,[1 2 3]);
% 
% tiledlayout(4,1)
% nexttile
% plot(approx)
% title("Approximation Coefficients")
% nexttile
% plot(cd3)
% title("Level 3 Detail Coefficients")
% nexttile
% plot(cd2)
% title("Level 2 Detail Coefficients")
% nexttile
% plot(cd1)
% title("Level 1 Detail Coefficients")

 %% Visualization
% % FFT Spectra
% figure;
% subplot(2,1,1);
% plot(frequency, fft_signal(1:L/2));
% xlabel('Frequency');
% ylabel('Amplitude');
% title('Ball FFT Spectra');
% xlim([20 400])
% 
% Envelope Spectra
subplot(2,1,2);
plot(frequency, fft_envelope(1:L/2));
xlabel('Frequency');
ylabel('Amplitude');
xlim([0 500])


%Discrete wavelet packet transform
wpt = wpdec(Inner_DE, 3, 'db1'); %DWT
figure;
for k = 1:length(wpt)
    subplot(4, 2, k);
    [pEnv, fEnv] = envspectrum(wpt(k, :), fs); %Envelope 
    plot(fEnv, pEnv);
    xlim([0 400]);
    ylabel('Amptitude');
end




