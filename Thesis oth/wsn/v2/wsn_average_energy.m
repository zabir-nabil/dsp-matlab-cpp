% row -> hops, columns -> distance
dis = [0, 0, 0, 0;50,45,55,52;100,90,110,104;150,135,165,156];
num_hops = 3;
num_nodes = 4;

Eelec = 50*1e-9;
Eda = 5*1e-9;
Eamp = 100*1e-12;
k_all = [25,50,75,100]*8;

trans_energy = zeros(3,4);
rec_energy = zeros(3,4);
tot_energy = zeros(3,4);


average_energy_k = zeros(4,1);
average_energy_first_hop_k = zeros(4,1);
tot_energy_k = zeros(4,1);
tot_energy_fh_k = zeros(4,1);

for ck = 1:4
    k = k_all(ck);
    for hops = num_hops:-1:1
        for nodes = 1:num_nodes
            d = dis(hops,nodes) - dis(hops+1,nodes);
            trans_energy(hops,nodes) = k*(Eelec+Eda+Eamp*d^2); % Etx(k,d)
            rec_energy(hops,nodes) = Eelec*k;
            tot_energy(hops, nodes) = trans_energy(hops,nodes) + rec_energy(hops,nodes);
        end
        k = k + k;
    end
average_energy_k(ck) = sum(sum(tot_energy))/(num_hops*num_nodes);
average_energy_first_hop_k(ck) = sum(sum(tot_energy(1,:)-sum(tot_energy(2:3,:))))/(1*num_nodes);
disp('Average energy: ');
disp(average_energy_k(ck));
disp('Average energy first hop: ');
disp(average_energy_first_hop_k(ck));
disp('Total energy: ');
tot_energy_k(ck) = sum(sum(tot_energy));
disp(tot_energy_k(ck));
tot_energy_fh_k(ck) = sum(sum(tot_energy(1,:)));
disp('Total energy first hop: ');
disp(tot_energy_fh_k(ck));
end



plot(k_all,average_energy_k);
hold on,
plot(k_all,average_energy_first_hop_k);
hold on,
plot(k_all,tot_energy_k);
hold on,
plot(k_all,tot_energy_fh_k*(1/3));
xlabel('Bits k');
ylabel('energy (J)');
title('Energy for different k');
legend('Average Energy','Average energy first hop','Total energy', 'Total energy first hop');
