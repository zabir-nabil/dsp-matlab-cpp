fileID = fopen('toma.txt','r');

data = fscanf(fileID,'%f	%f');

X = zeros(15*2,10);

X(1,:) = data(1:10);

for i = 1:15
    X(i,:) = data(20*(i-1)+1:2:20*i);
end

for i = 16:30
    j = i - 15;
    X(i,:) = data(20*(j-1)+2:2:20*j);
end


y = [0*ones(1,15), 1*ones(1,15)];
