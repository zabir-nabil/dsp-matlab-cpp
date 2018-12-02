% row -> hops, columns -> distance
dis = [50,45,55,52;100,95,97,105;150,145,155,152];
num_hops = 3;
num_nodes = 4;

Eelec = 50*1e-9;
Eda = 5*1e-9;
Eamp = 100*1e-12;
k = 25*8;

trans_energy = zeros(3,4);
rec_energy = zeros(3,4);
tot_energy = zeros(3,4);


for hops = 1:num_hops
    for nodes = 1:num_nodes
        d = dis(hops,nodes);
        trans_energy(hops,nodes) = k*(Eelec+Eda+Eamp*d^2); % Etx(k,d)
        rec_energy(hops,nodes) = Eelec*k;
        tot_energy(hops, nodes) = trans_energy(hops,nodes) + rec_energy(hops,nodes);
    end
end

average_energy = sum(sum(tot_energy))/(num_hops*num_nodes);
average_energy_first_hop = sum(sum(tot_energy(1,:)))/(1*num_nodes);
disp('Average energy: ');
disp(average_energy);
disp('Average energy first hop: ');
disp(average_energy_first_hop);
disp('Total energy: ');
disp(sum(sum(tot_energy)));
disp('Total energy first hop: ');
disp(sum(sum(tot_energy(1,:))));

plot(sum(tot_energy'));
hold on,
plot(sum(trans_energy'));
hold on,
plot(sum(rec_energy'));
xlabel('Hop number');
ylabel('energy (J)');
legend('total energy','transmitted energy','recieved energy');

        