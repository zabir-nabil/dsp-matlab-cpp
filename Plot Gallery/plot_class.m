x = [0.5 1 1.5 2 2.3 2.6 3 4];
y = [51/1000 51.8/1000 51.8/1000 51.8/1000,...
    .755 .755 .755 .755];
plot(x,y);

hold on,

x = [4 3.4 3 2.8 2.48 2.1 1.5 1];
y = [.749 .748 .749 .749, .749...
    51.8/1000 51.8/1000 51.8/1000];
plot(x,y,'k');

hold on,
plot(2.3,.755,'r*');

hold on,
plot(2.1,51.8/1000,'g*');

title('Hysteresis curve (Pulse Transmitter and Analog Receiver)');
xlabel('Transmitter voltage (V)');
ylabel('Reciever voltage (v)');
legend('Increasing voltage','Decreasing voltage',...
    'Turn on voltage','Turn off voltage');
