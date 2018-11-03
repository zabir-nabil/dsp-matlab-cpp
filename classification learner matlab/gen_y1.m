function vector_y1 = gen_y1(num_samples,n_s_p)

y1 = zeros(num_samples,n_s_p);
x = 1:n_s_p;
for i=1:num_samples
        y1(i,:) = cos(x).*sin(x) + ...
        sin(x) + 4*rand(1,n_s_p);    
end
vector_y1 = y1;
end