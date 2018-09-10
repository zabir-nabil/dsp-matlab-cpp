% Data source: https://github.com/zabir-nabil/dsp-matlab-cpp/tree/master/Thesis%20oth/bme_lab_1
% author: zabiralnazi@yahoo.com
emg_data = load('EMG_dataset.mat');
emg_data = emg_data.data;
signal_taken = 8000;
X= emg_data(1:signal_taken,1);
fs = 100; % assumed approximately, no info given in the data
figure(1);
plot(X,'r');
title('Raw EMG Signal');
xlabel('Time Index');
ylabel('Amplitude');

rectified_signal = abs(X);
figure(2);
plot(rectified_signal,'g');
title('Rectified EMG signal');
xlabel('Time Index');
ylabel('Amplitude');

cut_off_param = 0.1; % tuned to find better envelope
[b1,a1] = butter(5,cut_off_param,'low');
y = filter(b1,a1,rectified_signal);
figure(3);
plot(y);
title('Envelope of rectified signal')
xlabel('Time Index')
ylabel('Amplitude')
integrated = cumtrapz(y);
figure(4);
plot(integrated,'m');
title('Integrated Signal');
xlabel('Time Index');
ylabel('Amplitude');