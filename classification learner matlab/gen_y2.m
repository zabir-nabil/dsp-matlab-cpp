function vector_y1 = gen_y2(num_samples,n_s_p)

y1 = zeros(num_samples,n_s_p);
x = 1:n_s_p;
for i=1:num_samples
        y1(i,:) = 1.2*cos(x).*sin(x) + ...
        0.89*sin(x) + 4.2*rand(1,n_s_p);    
end
vector_y1 = y1;
end