% row -> hops, columns -> distance
dis = 50;
num_hops = 4;
num_nodes = 8;

Eelec = 50*1e-9;
Eda = 0; %5*1e-9;
Eamp = 100*1e-12;
k_all = [25, 50, 75]*8;

trans_energy = zeros(4,8);
rec_energy = zeros(4,8);
tot_energy = zeros(4,8);

toenk = zeros(4,3,8);

average_energy_k = zeros(4,1);
average_energy_first_hop_k = zeros(4,1);
tot_energy_k = zeros(4,1);
tot_energy_fh_k = zeros(4,1);

fin_eng = zeros(3,3);

for ck = 1:3
    k = k_all(ck);
    for hops = num_hops:-1:2
        for nodes = 1:num_nodes
            
            if hops == 2
            if nodes > 4    
            trans_energy(hops,nodes) = 0; % Etx(k,d)
            rec_energy(hops,nodes) = 0;
            tot_energy(hops, nodes) = 0;
            toenk(ck,hops,nodes) = 0;
            end
            if nodes <= 4    
            trans_energy(hops,nodes) = k*(Eelec+Eda+Eamp*d^2); % Etx(k,d)
            rec_energy(hops,nodes) = Eelec*k;
            tot_energy(hops, nodes) = trans_energy(hops,nodes) + rec_energy(hops,nodes);
            toenk(ck,hops,nodes) = tot_energy(hops, nodes);
            end
            end
            if hops ~= 2
            trans_energy(hops,nodes) = k*(Eelec+Eda+Eamp*d^2); % Etx(k,d)
            rec_energy(hops,nodes) = Eelec*k;
            tot_energy(hops, nodes) = trans_energy(hops,nodes) + rec_energy(hops,nodes);
            toenk(ck,hops,nodes) = tot_energy(hops, nodes);
            end
        
        
        
        end
        fin_eng(ck,:) = [sum(tot_energy(2,:)),sum(tot_energy(2,:)) + sum(tot_energy(3,:)),...
    sum(tot_energy(2,:))+sum(tot_energy(4,:))+sum(tot_energy(3,:))];

        k = k*(5-hops);
    end
end


figure(2);
plot([2,3,4],fin_eng(1,:));
hold on,
plot([2,3,4],fin_eng(2,:));
hold on,
plot([2,3,4],fin_eng(3,:));
xlabel('Hops');
ylabel('Energy (J)');
title('Hops vs Energy');