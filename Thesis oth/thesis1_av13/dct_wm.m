%function y = dct_wm()
% DCT based encoding
y = 0;
%warning('off', 'Images:initSize:adjustingMag');
I = imread('Test_img/cameraman.jpg');
I = I(:,:,1);
W = imresize(I,[512 512]);
Ic = I;

figure(1), imshow(Ic), title('Original Image');

W = imread('code.jpg');
W = rgb2gray(W);
W = imresize(W,[100 100]);
sf = size(W);
sf = sf(1,1)/8.00;
W = double(W);
figure(2), imshow(W,[]), title('Code');
[wm_s1, wm_s2] = size(W);
wmsz = wm_s1*wm_s2; %watermark size
I=I(:,:,1);%get the first color in case of RGB image
[r,c]=size(I);
D=dct2(I);%get DCT of the Asset
D_vec=reshape(D,1,r*c);%putting all DCT values in a vector
[D_vec_srt,Idx]=sort(abs(D_vec),'descend');%re-ordering all the absolute values
W=reshape(W,1,wmsz);%generate a Gaussian spread spectrum noise to use as watermark signal
[rows, columns] = size(I);
Idx2=Idx(2:wmsz+1);%choosing 1000 biggest values other than the DC value
%finding associated row-column order for vector values
rows = rows*sf;
columns = columns*sf;
IND=zeros(wmsz,2);
for k=1:wmsz
x=floor(Idx2(k)/r)+1;%associated culomn in the image
y=mod(Idx2(k),r);%associated row in the image
IND(k,1)=y;
IND(k,2)=x;
end
D_w=D;
for k=1:wmsz
%insert the WM signal into the DCT values
if IND(k,1) < 1
    IND(k,1) = 1;
end
if IND(k,2) < 1
    IND(k,2) = 1;
end
D_w(IND(k,1),IND(k,2))=D_w(IND(k,1),IND(k,2))+.1*W(k);
end
I2=idct2(D_w);%inverse DCT to produce the watermarked asset
figure(3),
imshow(I2,[]),
title('Watermarked Image');
% adding noise
%I2 = im2double(I2);
normalizedImage = uint8(255*mat2gray(I2));
I2 = imnoise(normalizedImage,'poisson');


% noise remove filter 
%I2 = wiener2(I2,[10 10]);
figure(4),
imshow(I2,[]),
title('Reconstructed Image');

W2=[];%will contain watermark signal extracted from the image
for k=1:wmsz
temp = D_w(IND(k,1),IND(k,2)) - D(IND(k,1),IND(k,2));
%temp = temp/D_w(IND(k,1),IND(k,2));
W2(k) = temp*10;
end
W2 = reshape(W2,wm_s1,wm_s2);
W2 = imsharpen(W2);
W2 = im2bw(W2);
figure(5),
imshow(W2,[]),
title('Extrcated Code');

[PSNR_OUT,Z] = psnr(I,I2);
squaredErrorImage = (double(I) - double(I2)) .^ 2;
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  It will be a scalar (a single number).

mse = sum(sum(squaredErrorImage)) / (rows * columns);

y = [mse PSNR_OUT];

figure(5),
a = bar(y,'b'),
title('Reconstructed image vs Original Image');


labels = {'mse', 'psnr'};

xt = get(gca, 'XTick');
text(xt, y, labels, 'HorizontalAlignment','center', 'VerticalAlignment','bottom')
I = im2double(I);
I2 = im2double(I2);
%val_sim = ssim(I2,I);
%disp('Structural Similarity (Original vs Reconstructed) : ');
%disp(val_sim);

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
sf_den=sqrt((sf_den+a*b));
end
end
sf=(sf_num/sf_den);

disp('Similarity factor (Original vs Reconstructed): ');
disp(sf);