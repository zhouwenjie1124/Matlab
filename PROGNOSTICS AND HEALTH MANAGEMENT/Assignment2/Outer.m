%% Load Data
% Outer Race
load("OR007@6_2_296.mat")


fs12k = 12000;
fs =12000;

%% time domain
i_data_size = size(X296_DE_time,1);
t = 0:1/fs12k:(i_data_size - 1)/fs12k;
Inner_DE = X296_DE_time(:,1);

%% Envelope analysis

% hilbert_transform
hilbert_transform = hilbert(Inner_DE);

% envelope
envelope = abs(hilbert_transform);

%% FFT
FFT = fft(Inner_DE);
L = length(Inner_DE);
frequency = (0:L/2-1)*(fs12k/L); 
fft_signal = abs(FFT);
fft_envelope = abs(fft(envelope));

%%
[c,l] = wavedec(Inner_DE,4,'db1');
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
    [pEnvInner, fEnvInner, xEnvInner, tEnvInner] = envspectrum(tempx, fs);plot(fEnvInner, pEnvInner)
    xlim([0 400]);hold on;
    %ncomb = 20;helperPlotCombs(ncomb,5.480*v);
end

%% Visualization
% % FFT Spectra
% figure;
% subplot(2,1,1);
% plot(frequency, fft_signal(1:L/2));
% xlabel('Frequency');
% ylabel('Amplitude');
% title('Outer Race FFT Spectra');
% xlim([20 800])
% 
% % Envelope Spectra
% subplot(2,1,2);
% plot(frequency, fft_envelope(1:L/2));
% xlabel('Frequency');
% ylabel('Amplitude');
% title('Outer Race Envelope Spectra');
% xlim([20 800])




