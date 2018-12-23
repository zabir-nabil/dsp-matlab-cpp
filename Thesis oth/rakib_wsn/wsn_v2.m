% row -> hops, columns -> distance
dis = [10,20,30,50];
num_hops = 4;
num_nodes = 8;

Eelec = 50*1e-9;
Eda = 0; %5*1e-9;
Eamp = 100*1e-12;
k = 25*8;

trans_energy = zeros(4,8);
rec_energy = zeros(4,8);
tot_energy = zeros(4,8);

toenk = zeros(4,3,8);

average_energy_k = zeros(4,1);
average_energy_first_hop_k = zeros(4,1);
tot_energy_k = zeros(4,1);
tot_energy_fh_k = zeros(4,1);

for ck = 1:4
    k = 25*8;
    d = dis(ck);
    for hops = num_hops:-1:2
        for nodes = 1:num_nodes
            trans_energy(hops,nodes) = k*(Eelec+Eda+Eamp*d^2); % Etx(k,d)
            rec_energy(hops,nodes) = Eelec*k;
            tot_energy(hops, nodes) = trans_energy(hops,nodes) + rec_energy(hops,nodes);
            toenk(ck,hops,nodes) = tot_energy(hops, nodes);
        end
        k = k*(5-hops);
    end
average_energy_k(ck) = sum(sum(tot_energy))/((num_hops-1)*num_nodes);
average_energy_first_hop_k(ck) = sum(sum(tot_energy(2,:)))/(3*num_nodes);
disp('Average energy: ');
disp(average_energy_k(ck));
disp('Average energy first hop: ');
disp(average_energy_first_hop_k(ck));
disp('Total energy: ');
tot_energy_k(ck) = sum(sum(tot_energy));
disp(tot_energy_k(ck));
tot_energy_fh_k(ck) = sum(sum(tot_energy(2,:)))/3;
disp('Total energy first hop: ');
disp(tot_energy_fh_k(ck));
end


figure(1);
plot(dis,average_energy_k);
hold on,
plot(dis,average_energy_first_hop_k);
hold on,
plot(dis,tot_energy_k);
hold on,
plot(dis,tot_energy_fh_k*(1/3));
xlabel('Distance d');
ylabel('Energy (J)');
title('Distance');
legend('Average Energy','Average energy first hop','Total energy', 'Total energy first hop');
tot_energy(2,:) = tot_energy(2,:)/2;
hop_energy = [sum(tot_energy(2,:)),sum(tot_energy(2,:)) + sum(tot_energy(3,:)),...
    sum(tot_energy(2,:))+sum(tot_energy(4,:))+sum(tot_energy(3,:))];

disp('Hop by Hop energy');
disp(hop_energy);
figure(2);
plot([2,3,4],hop_energy);
xlabel('Hops');
ylabel('Energy (J)');
title('Hops vs Energy');