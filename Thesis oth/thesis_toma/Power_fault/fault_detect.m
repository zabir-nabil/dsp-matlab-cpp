% Dummy Power Transmission Signal X(t)

read_file(); % 100 signal sample points, 500 total samples


y = y';
[samp_n, sig_len] = size(X);
features = zeros(samp_n,9);
for i = 1:samp_n
disp(i);
disp('...');
EMD_X = emd(X(:,i));

% only 3 components taken based on paper
HILBERT_X1 = hilbert(EMD_X(1,:));
HILBERT_X2 = hilbert(EMD_X(2,:));
HILBERT_X3 = hilbert(EMD_X(3,:));

data_pts = length(HILBERT_X1);
% Feature 1, Energy
rms1 = sqrt(sum(abs(HILBERT_X1).^2)/data_pts);
rms2 = sqrt(sum(abs(HILBERT_X2).^2)/data_pts);
rms3 = sqrt(sum(abs(HILBERT_X3).^2)/data_pts);

% Feature 2, Standard Deviation of Absolute Amplitude
std1 = std(abs(HILBERT_X1));
std2 = std(abs(HILBERT_X2));
std3 = std(abs(HILBERT_X3));

% Feature 3, Standard Deviation of Angle
std1_a = std(angle(HILBERT_X1));
std2_a = std(angle(HILBERT_X2));
std3_a = std(angle(HILBERT_X3));

feature = [rms1, rms2, rms3,...
    std1, std2, std3, ...
    std1_a, std2_a, std3_a];
features(i,:) = feature;
end
no_class = 10;
for c = 1:no_class
    y_cop = y(:)';
    idx = find(y_cop~=c);
    y_cop(idx) = 0;
svmStruct = svmtrain(features,y_cop,'ShowPlot',true);
disp('Predicted Class Labels')
Group = svmclassify(svmStruct,features,'Showplot',true)
tot = length(y_cop);
cnt = 0;
for x = 1:tot
    if Group(x) == y_cop(x)
        cnt = cnt + 1;
    end
end
disp('Accuracy');
disp(cnt/tot*100.00);
disp('%');
end