%function y = dct_wm()
% DCT based encoding
y = 0;
%warning('off', 'Images:initSize:adjustingMag');
I = imread('boats.tif');
Ic = I;
figure(1), imshow(Ic), title('Original Image');
k = 0.01;
W = imread('code.jpg');
W = rgb2gray(W);
W = imresize(W,[256 256]);
W = double(W);
figure(2), imshow(W,[]), title('Code');
[wm_s1, wm_s2] = size(W);
wmsz = wm_s1*wm_s2; %watermark size
I=I(:,:,1);%get the first color in case of RGB image
[r,c]=size(I);


% Transform
[CA,CH,CV,CD] = dwt2(I,'db1');
T_res = [CH CV CD];
size(CH);
size(CV);
size(CD);
hc_cl = 256;
T_res = reshape(T_res,1,3*hc_cl^2);
Wp = reshape(W,1,wm_s1*wm_s2);
CH2 = CH;
for i = 1:wmsz
    T_res(i) = T_res(i) + 0.1*Wp(i);
    CH2(i) = CH2(i) + k*Wp(i);
end

T_res = reshape(T_res,[hc_cl,hc_cl,3]);
size(T_res)
CHp = T_res(:,:,1);
CVp = T_res(:,:,2);
CDp = T_res(:,:,3);
R_res = [CA CH2 CV CD];
waterImg = idwt2(CA,CH2,CV,CD,'db1');
figure(3), imshow(waterImg,[]), title('Watermarked Image');


[PSNR_OUT,Z] = psnr(I,waterImg);
squaredErrorImage = (double(I) - double(waterImg)) .^ 2;
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  It will be a scalar (a single number).
[rows, columns] = size(I);
mse = sum(sum(squaredErrorImage)) / (rows * columns);

disp('For encoded Image');
str = sprintf('PSNR = %f',PSNR_OUT);

disp(str);

str = sprintf('MSE = %f',mse);

disp(str);

figure(100),
title('Original vs Encoded');
somedata=[PSNR_OUT, mse];
somenames={'PSNR', 'MSE'};
bar(somedata,'b')
set(gca,'xticklabel',somenames)


%channel
%watercop = uint8(waterImg*255);
watercop = im2double(waterImg);
noiseImg = imnoise(I,'poisson');

figure(4), imshow((noiseImg)), title('Noise Image');
% extract

%filterImg = wiener2(noiseImg,[5 5]);
%figure(5), imshow(filterImg,[]), title('Filtered Image');

[CAp, CHp, CVp, CDp] = dwt2(waterImg,'db1');
T_res2 = [CHp CVp CDp];
size(CH);
size(CV);
size(CD);
hc_cl = 256;
T_res2 = reshape(T_res2,1,3*hc_cl^2);
Wp = zeros(1,wm_s1,wm_s2);

for i = 1:wmsz
    temp = T_res2(i) - T_res(i);
    CD(i) = CD(i) + 0.5*Wp(i);
    %temp = temp/T_res(i);
    temp = CHp(i) - CH(i);
    Wp(i) = temp*(1/k);
    CHp(i) = CHp(i) - Wp(i)*k;
    
end

reconImg = idwt2(CA, CHp, CV, CD, 'db1');
normalizedImage = uint8(255*mat2gray(reconImg));
%figure(11), imshow(normalizedImage), title('Normalized');
noiseImg = imnoise(normalizedImage,'poisson');

%figure(4), imshow((noiseImg)), title('Noise Image');
% extract

filterImg = wiener2(normalizedImage,[5 5]);

figure(6), imshow(filterImg), title('Reconstructed Filtered Image');


[PSNR_OUT,Z] = psnr(I,filterImg);
squaredErrorImage = (double(I) - double(filterImg)) .^ 2;
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  It will be a scalar (a single number).
[rows, columns] = size(I);
mse = sum(sum(squaredErrorImage)) / (rows * columns);

disp('Reconstructed Image');
str = sprintf('PSNR = %f',PSNR_OUT);

disp(str);

str = sprintf('MSE = %f',mse);

disp(str);

figure(102),
title('Original vs Reconstructed');
somedata=[PSNR_OUT, mse];
somenames={'PSNR', 'MSE'};
bar(somedata,'r')
set(gca,'xticklabel',somenames)


Wp = reshape(Wp,wm_s1,wm_s2);
Wp = imnoise(Wp,'poisson');
Wp = wiener2(Wp,[5 5]);
figure(7), imshow(Wp,[]), title('Extracted Code');