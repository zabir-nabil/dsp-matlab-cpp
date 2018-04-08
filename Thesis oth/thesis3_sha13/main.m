% Main 
clc;
clear all;
close all;

% read image and convert to gray scale if necessary
originalImage = imresize(imread('Test_img/cameraman.jpg'),[512 512],'bicubic');
originalImage = originalImage(:,:,1);
originalImage = imresize(originalImage,[512 512],'bicubic');

if 1
    %originalImage = rgb2gray(originalImage);
end


encoding(originalImage, 'poisson');

%disp('Waiting 15 secs before extraction....');
%pause(15);

%clc;
%close all;
