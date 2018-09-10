% Data source: 
% author: zabiralnazi@yahoo.com
% eeg band
% theta: 4–7
% alpha: 8–15
% beta: 16–31
% gamma: > 35
eeg_data = load('sample_eeg.mat');
eeg_data = eeg_data.sample_eeg(1,:,:);

% parameters
N=4; % 4th order
fs = 128; % sample rate
time = 0:1/fs:(length(eeg_data)-1)*1/fs;

% Just working with a single channel
figure(1);
plot(time, eeg_data);
xlabel('Time(s)');
ylabel('Amplitude');
title('Raw EEG Signal');


W1 = 4/fs; % change this to be initial frequency
W2 = 7/fs; % change this to final frequency
Wn_t = [W1 W2];
[c,d] = butter(N,Wn_t);
theta = filter(c,d,eeg_data); % where deg is you eeg data
figure(2);
plot(time, theta, 'r');
xlabel('Time(s)');
ylabel('Amplitude');
title('Theta Wave');

W1 = 8/fs; % change this to be initial frequency
W2 = 15/fs; % change this to final frequency
Wn_t = [W1 W2];
[c,d] = butter(N,Wn_t);
alpha = filter(c,d,eeg_data); % where deg is you eeg data
figure(3);
plot(time, alpha, 'k');
xlabel('Time(s)');
ylabel('Amplitude');
title('Alpha Wave');

W1 = 16/fs; % change this to be initial frequency
W2 = 31/fs; % change this to final frequency
Wn_t = [W1 W2];
[c,d] = butter(N,Wn_t);
beta = filter(c,d,eeg_data); % where deg is you eeg data
figure(4);
plot(time, beta, 'g');
xlabel('Time(s)');
ylabel('Amplitude');
title('Beta Wave');


[c,d] = butter(N,31/fs,'high');
beta = filter(c,d,eeg_data); % where deg is you eeg data
figure(5);
plot(time, beta, 'm');
xlabel('Time(s)');
ylabel('Amplitude');
title('Gamma Wave');