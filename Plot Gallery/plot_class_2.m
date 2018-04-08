f = [100 500 1000 5000 10000 30000,...
    100000 200000 400000 600000 800000,...
    1000000 1200000];

g = [1.477 1.465 1.45 1.44 1.47 1.45 1.46,...
    1.44 1.44 1.45 1.44 1.44 0.048];


plot(f,g);

hold on,
plot(1.055*1000000,1.044,'r*');
hold on,
x = [0 1.055*1000000];
y = [1.044 1.044];
plot(x,y,'r');

hold on,
x = [1.05499*1000000 1.055*1000000];
y = [0 1.044];
plot(x,y,'r');


title('Plot for Frequency vs Gain');
xlabel('Frequency (Hz)');
ylabel('Gain (V_o/V_i)');
legend('Frequency vs Gain','3dB point (1.055 MHz, 1.044)')
