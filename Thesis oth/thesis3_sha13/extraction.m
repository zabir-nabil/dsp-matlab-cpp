function y = extraction(noise_type)
load WatermarkInfo.mat;
disp('------------------------ Extraction -------------------------------');

% read image and convert to gray scale if necessary
originalImage = imresize(imread('peppers.tif'),[512 512],'bicubic');
if (size(originalImage(:,3))==3)
    originalImage = rgb2gray(originalImage);
end

% read image and convert to gray scale if necessary
% a = imread('Watermarked Image.bmp');
% get the single channel
% a = a(:,:,1);
a = watermarkedImage;
%figure,imshow(a,[]),title('Noise added Image');
%bsa = imnoise(a,'gaussian',0,0.0001); 
%figure,imshow(b,[]),title('Noise added Image');
%bsa = im2uint8(bsa);
%imshow(bsa,[]);
% STEP 1: perfom integer wavelet decomposition
% cdf2.2, haar, sym2, cdf1.1, cdf3.5
LS = liftwave('cdf4.6','Int2Int');
[CA,CH,CV,CD] = lwt2(double(a),LS);
%[CA,CH,CV,CD] = dwt2(double(img),'haar');

% STEP 2: extract the embeded signal from 5th bit of CH, CV and CD
index = 1;
% preallocate memory to fasten things
embededSignal = zeros(size(CH,1)*size(CH,2)+size(CV,1)*size(CV,2)+size(CD,1)*size(CD,2),1);
for i=1:size(CH,1)
    for j=1:size(CH,2)
        % for constructing binary image using CH
        if CH(i,j) ~= -ERROR_NUM
            binSeq = dec2bin(abs(CH(i,j)),8);
            if binSeq(BITPLANE_NUMBER) == '1'
                embededSignal(index,1) = 1;
            else
                embededSignal(index,1) = 0;
            end
            index = index + 1;        
        end
    end
end

% extract the embeded signal from 5th bit of CV
for i=1:size(CV,1)
    for j=1:size(CV,2)
        % for constructing binary image using CV
        if CV(i,j) ~= -ERROR_NUM        
            binSeq = dec2bin(abs(CV(i,j)),8);
            if binSeq(BITPLANE_NUMBER) == '1'
                embededSignal(index,1) = 1;
            else
                embededSignal(index,1) = 0;
            end
            index = index + 1;        
        end
    end
end

% extract the embeded signal from 5th bit of CD
for i=1:size(CD,1)
    for j=1:size(CD,2)
        % for constructing binary image using CD
        if CD(i,j) ~= -ERROR_NUM        
            binSeq = dec2bin(abs(CD(i,j)),8);
            if binSeq(BITPLANE_NUMBER) == '1'
                embededSignal(index,1) = 1;
            else
                embededSignal(index,1) = 0;
            end
            index = index + 1;        
        end
    end
end

% STEP 3: extract header information
% obtain count1 of CH for use in aritmatic decoding
binNum = '';
for i=1:8
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count1(1,1) = num;

binNum = '';
for i=9:16
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count1(1,2) = num;

% obtain count2 of CV for use in aritmatic decoding
binNum = '';
for i=17:24
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count2(1,1) = num;

binNum = '';
for i=25:32
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count2(1,2) = num;

% obtain count3 of CD for use in aritmatic decoding
binNum = '';
for i=33:40
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count3(1,1) = num;

binNum = '';
for i=41:48
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
count3(1,2) = num;

% obtain length of compressed CH
binNum = '';
for i=49:64
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
lenCH5 = num;

% obtain length of compressed CV
binNum = '';
for i=65:80
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
lenCV5 = num;

% obtain length of compressed CD
binNum = '';
for i=81:96
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
lenCD5 = num;

% obtain length of watermark
binNum = '';
for i=97:128
    if embededSignal(i,1) == 1
        binNum = strcat(binNum,'1');
    else
        binNum = strcat(binNum,'0');    
    end
end
num = bin2dec(binNum);
lenWatermark = num;

% STEP 4: Extract the respective signals CH, CV, CD and decode(uncompress) to get the original bit sequence  
HL = 128;
% construct sequence 1(CH) and decode
seq11 = embededSignal(HL+1:(HL+lenCH5));
CH5 = arithdeco(seq11,count1,size(CH,1)*size(CH,2)); 

% construct sequence 2(CV) and decode
seq22 = embededSignal((HL+lenCH5)+1:(HL+lenCH5+lenCV5));
CV5 = arithdeco(seq22,count2,size(CV,1)*size(CV,2)); 

% construct sequence 3(CD) and decode
seq33 = embededSignal((HL+lenCH5+lenCV5)+1:(HL+lenCH5+lenCV5+lenCD5));
CD5 = arithdeco(seq33,count3,size(CD,1)*size(CD,2)); 

% additional step is to verify the embeded watermark so extract it (not compared to the original but can be)
watermarkE = embededSignal((HL+lenCH5+lenCV5+lenCD5)+1:(HL+lenCH5+lenCV5+lenCD5+lenWatermark));
watermarkE = imnoise(watermarkE,noise_type);
watermarkE = wiener2(watermarkE,[5 5]);
%if isequal(watermark,watermarkE')
%    disp('Watermark correct');
%else
%    disp('Watermark Error')    
%end
watermarkE = reshape(watermarkE,WM_SIZE,WM_SIZE);
%watermarkE = im2bw(watermarkE,0.3);
figure(10),imshow(watermarkE,[]),title('Retrieved Watermark')

% STEP 5: Restore the Image i.e. remove the watermark and insert the
% uncompressed 5th bit data back into the image
CH5 = reshape(CH5,size(CH,1),size(CH,1));
CV5 = reshape(CV5,size(CV,1),size(CV,1));
CD5 = reshape(CD5,size(CD,1),size(CD,1));

neg = 0;

for x=1:size(CH,1)
    for y=1:size(CH,2)
        if CH(x,y) ~= -ERROR_NUM
            % restore 5th bit of CH
            neg = 0;
            if CH(x,y) < 0
                neg = 1;
            end
            binSeq = dec2bin(abs(CH(x,y)),8);
            if CH5(x,y) == 2
                binSeq(BITPLANE_NUMBER) = '1';
            else
                binSeq(BITPLANE_NUMBER) = '0';
            end
            num = bin2dec(binSeq);
            if neg == 1
                CH(x,y) = num * -1;
            else
                CH(x,y) = num;
            end
        end        
        % restore 5th bit of CV
        if CV(x,y) ~= -ERROR_NUM        
            neg = 0;
            if CV(x,y) < 0
                neg = 1;
            end
            binSeq = dec2bin(abs(CV(x,y)),8);
            if CV5(x,y) == 2
                binSeq(BITPLANE_NUMBER) = '1';
            else
                binSeq(BITPLANE_NUMBER) = '0';
            end
            num = bin2dec(binSeq);
            if neg == 1
                CV(x,y) = num * -1;
            else
                CV(x,y) = num;
            end
        end
        
        % restore 5th bit of CD
        if CD(x,y) ~= -ERROR_NUM        
            neg = 0;
            if CD(x,y) < 0
                neg = 1;
            end
            binSeq = dec2bin(abs(CD(x,y)),8);
            if CD5(x,y) == 2
                binSeq(BITPLANE_NUMBER) = '1';
            else
                binSeq(BITPLANE_NUMBER) = '0';
            end
            num = bin2dec(binSeq);
            if neg == 1
                CD(x,y) = num * -1;
            else
                CD(x,y) = num;
            end
        end
    end
end

%STEP 6: Take inverse integer wavelet transform to get the original
%distortionless image back
restoredImage = ilwt2(CA,CH,CV,CD,LS);
%figure,imshow(restoredImage,[]),title('Restored Image (Distortionless)');
%restoredImage = imnoise(restoredImage,'gaussian');
difference = abs(double(img) - double(restoredImage));
squaredErrorImage = (double(img) - double(restoredImage)) .^ 2;
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  It will be a scalar (a single number).
%[rows, columns] = size(img);
%restoredImage = imnoise(restoredImage,noise_type);
restoredImage = wiener2(restoredImage,[5 5]);
%mse = sum(sum(squaredErrorImage)) / (rows * columns);
%str = sprintf('MSE = %f',mse);

%disp(str);
%close all;
figure(7), imshow(restoredImage,[]),title('Restored Image');
%imshow(originalImage);

restoredImage = wiener2(restoredImage,[5 5]);
[PSNR_OUT,Z] = psnr(restoredImage, img);
squaredErrorImage = (double(restoredImage) - double(img)) .^ 2;

% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  It will be a scalar (a single number).
[rows, columns] = size(originalImage);
mse = sum(sum(squaredErrorImage)) / (rows * columns);

figure(11),
title('Original vs Restored');
somedata=[PSNR_OUT, mse];
somenames={'PSNR', 'MSE'};
bar(somedata,'r')
set(gca,'xticklabel',somenames);

disp('Restored Image');
str = sprintf('PSNR = %f',PSNR_OUT);

disp(str);

str = sprintf('MSE = %f',mse);

disp(str);