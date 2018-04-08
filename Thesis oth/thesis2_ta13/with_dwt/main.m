% Main 
clc;
clear all;
close all;

% read image and convert to gray scale if necessary
originalImage = imresize(imread('peppers.tif'),[512 512],'bicubic');
if (size(originalImage(:,3))==3)
    originalImage = rgb2gray(originalImage);
end


encoding(originalImage, 'poisson');

%disp('Waiting 15 secs before extraction....');
%pause(15);

%clc;
%close all;
