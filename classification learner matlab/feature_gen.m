function f_1 = feature_gen(yy,class_lab)
[r, c] = size(yy);
feature_mat = zeros(r,4);

for i=1:r
    feature_mat(i,:) = feature_ext(yy(i,:),class_lab);
end

f_1 = feature_mat;
end