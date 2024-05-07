%% Generate a simulated signal 
fs = 2580;
t = 0:(1/fs):(2 - 1/fs); % step is 1/fs ,length is 2 - 1/fs
X = 5*sin(2*pi*267*t) + 2*sin(2*pi*19*t) + sin(2*pi*3*t);
figure(1)
subplot(2,1,1)
plot(t,X)
xlabel('Time (s)'); ylabel('Amplitude')
subplot(2,1,2)
plot(t,X)
xlabel('Time (s)'); ylabel('Amplitude')
xlim([0 0.2])


%% FFT
FFT = fft(X);
L = length(X);
Spectrum = abs(FFT(1:L/2+1))/L*2;
figure(2)
subplot(2,1,1)

plot((0:L/2)/L*fs,Spectrum)
xlabel('Frequency (Hz)'); ylabel('Amplitude')

plot((0:L/2)/L*fs,Spectrum)
xlabel('Frequency (Hz)'); ylabel('Amplitude')

%% EMD 
[imf,residual] = emd(X);
figure(3)
[~,n] = size(imf);
for i = 1:n
    subplot(n+1,1,i) 
    plot(t,imf(:,i)) 
    ylabel(['IMF ', num2str(i)])
end
   subplot(n+1,1,i+1)
   plot(t,residual)
   ylabel("residual")
xlabel('Time (s)');

%% USE FFT to get the spectra of imfs of the decompsed simulated signal
figure(4)
for i = 1:n
    subplot(n,1,i)
    FFTTemp = fft(imf(:,i));
    SpectrumTemp = abs(FFTTemp(1:L/2+1))/L*2; plot((0:L/2)/L*fs,SpectrumTemp)
    ylabel(['IMF ', num2str(i)])
    xlim([0 300])
end
xlabel('Frequency (Hz)');

%% Change the simulated siganl and observe the EMD results 
X = 3*sin(2*pi*199*t) + 5*sin(2*pi*37*t) + 2*sin(2*pi*7*t); [imf,residual] = emd(X);
figure(5)
[~,n] = size(imf);
for i = 1:n
    subplot(n,1,i) 
    plot(t,imf(:,i)) 
    ylabel(['IMF ', num2str(i)])
end
xlabel('Time (s)'); 
figure(6)
for i = 1:n
    subplot(n,1,i)
    FFTTemp = fft(imf(:,i));
    SpectrumTemp = abs(FFTTemp(1:L/2+1))/L*2; plot((0:L/2)/L*fs,SpectrumTemp)
    ylabel(['IMF ', num2str(i)])
    xlim([0 300])
end
xlabel('Frequency (Hz)')



