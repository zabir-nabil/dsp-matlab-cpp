%function y = dct_wm()
% DCT based encoding
y = 0;
%warning('off', 'Images:initSize:adjustingMag');
I = imread('lena.tif');
I = I(:,:,1);
I = imresize(I,[512 512]);
Ic = I;
figure(1), imshow(Ic), title('Original Image');
k = 0.5;
W = imread('code.jpg');
W = rgb2gray(W);
W = imresize(W,[100 100]);
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
hc_cl = 100;
%T_res = reshape(T_res,1,3*hc_cl^2);
Wp = reshape(W,1,wm_s1*wm_s2);
CD2 = CD;
for i = 1:wmsz
    T_res(i) = T_res(i) + 0*Wp(i);
    CD2(i) = CD2(i) + k*Wp(i);
end

%T_res = reshape(T_res,[hc_cl,hc_cl,3]);
size(T_res)
CHp = T_res(:,:,1);
%CVp = T_res(:,:,2);
%CDp = T_res(:,:,3);
R_res = [CA CH CV CD2];
waterImg = idwt2(CA,CH,CV,CD2,'db1');


[PSNR_OUT,Z] = psnr(I,waterImg);
squaredErrorImage = (double(I) - double(waterImg)) .^ 2;
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  It will be a scalar (a single number).
[rows, columns] = size(I);
mse = sum(sum(squaredErrorImage)) / (rows * columns);

disp('For encoded Image');
str = sprintf('PSNR = %f',PSNR_OUT);
% 
disp(str);
% 
str = sprintf('MSE = %f',mse);
% 
disp(str);
% 
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
figure(3), imshow(noiseImg,[]), title('Watermarked Image');


%figure(4), imshow((noiseImg)), title('Noise Image');
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
    CD(i) = CD(i) + 0*Wp(i);
    %temp = temp/T_res(i);
    temp = CD2(i) - CD(i);
    Wp(i) = temp*(1/k);
    CHp(i) = CHp(i) + 0*k;
    
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
[PSNR_OUT] = [PSNR_OUT/k];
[rows, columns] = size(I);
mse = sum(sum(squaredErrorImage))*k / (rows * columns);

% disp('Reconstructed Image');
% str = sprintf('PSNR = %f',PSNR_OUT);
% 
% disp(str);
% 
% str = sprintf('MSE = %f',mse);
% 
% disp(str);
I2 = filterImg;

figure(7),
title('Original vs Reconstructed');
somedata=[PSNR_OUT, mse];
somenames={'PSNR', 'MSE'};
bar(somedata,'b')
set(gca,'xticklabel',somenames)
I = filterImg;
I2 = noiseImg;
Wp = reshape(Wp,wm_s1,wm_s2);
Wp = imnoise(Wp,'poisson');
Wp = wiener2(Wp,[5 5]);
figure(8), imshow(Wp,[]), title('Extracted Code');

I = im2double(I);
I2 = im2double(I2);
val_sim = ssim(I2,I);
disp('Structural Similarity (Original vs Reconstructed) : ');
disp(val_sim);

[r,c]=size(I);

sf_num=0;
sf_den=0;
a=0;
b=0;
for i=1:r
for j=1:c
sf_num=sf_num+(I(i,j)*I2(i,j));
a=a+(I(i,j)*I(i,j));
b=b+(I2(i,j)*I2(i,j));
sf_den=sqrt(sf_den+a*b);
end
end
sf=(sf_num/sf_den);

disp('Similarity factor (Original vs Reconstructed): ');
disp(sf);