function feature_response = feature_ext(y,class_lab)

% feature 1 = mean = abs(y)/n_s_p

% feature 2 = rms = sqrt(1/n_s_p(sqr(y)))

% feature 3 = difference = sum(yi+1 - yi)

feature_response = zeros(1,3+1);
feature_response(4) = class_lab;
[~, len] = size(y);

f1 = sum(abs(y))/len;

f2 = 0;
f3 = 0;
for i=1:len
    f2 = f2+((y(i)*y(i))/len);
    if i~=1
        f3 = f3 + abs(y(i)-y(i-1));
    end
end

f2 = sqrt(f2);

feature_response(1:3) = [f1, f2, f3];

end