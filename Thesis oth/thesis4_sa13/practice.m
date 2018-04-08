img=imread('noise_image.png');
%imshow(img);
figure(1), imshow(img), title('Main Image');
img = imresize(img,[392 392]);
N = 392;
embeding=img(1:392,1:392);
img=img(1:392,1:392);
%imshow(embeding);
alpha=zeros(1,2401);
cases=zeros(1,2401);
idx=1;
%disp(idx);
for i=1:8:392
  for j=1:8:392
    b=img(i:i+3,j:j+7);
    c=img(i+4:i+7,j:j+7);
    d=img(i:i+7,j:j+7);
    sum=0;
    left=0;
    mid=0;
    right=0;
    for k=1:4
      for l=1:8
        sum=sum+(b(k,l)-c(k,l));
        if (b(k,l)<85)
          left=left+1;
        elseif (b(k,l)<170)
          mid=mid+1;
        else
          right=right+1;
        end 
        if (c(k,l)<85)
          left=left+1;
        elseif (c(k,l)<170)
          mid=mid+1;
        else
          right=right+1;
        end
      end
    end
    sum=sum/32;
    alpha(idx)=sum;
%    fprintf("%d\n",sum);
    maxi=max(left,max(mid,right));
    
    if(left==mid && mid==right)
      cases(idx)=4;
    elseif(left==maxi)
      cases(idx)=1;
    elseif (mid==maxi)
      cases(idx)=2;
    else
      cases(idx)=3;
    end
    idx=idx+1;
  end
end

%disp(alpha);

fileid=fopen('Alpha.txt','w');
for i=1:idx-1
  fprintf(fileid,'alpha %5d = %3d \n',i,alpha(i));
end
fclose(fileid);

fileid=fopen('Cases.txt','w');
for i=1:idx-1
  fprintf(fileid,'Cases %5d = %3d\n',i,cases(i));
end
fclose(fileid);

%embeding start

idx=1;
for i=1:8:392
  for j=1:8:392
    b=embeding(i:i+3,j:j+7);
    c=embeding(i+4:i+7,j:j+7);
    d=embeding(i:i+7,j:j+7);
    if(cases(idx)==2)
        for k=i:1:i+7
            for l=j:1:j+7
                embeding(k,l)=embeding(k,l)+1;
            end
        end
    end
    idx=idx+1;
  end
end

%imshow(embeding);
figure(2), imshow(embeding), title('Embedded Image');
imwrite(embeding,'embeded_image.png');

 
noise_image=imnoise(embeding,'salt & pepper',0.02); 
imwrite(noise_image,'noise_image.png');
figure(3), imshow(noise_image), title('Noise Added Image');
denoise_image=modifiedMedianFiltering(noise_image,0,255);
imwrite(denoise_image,'denoise_image.png');
figure(4), imshow(denoise_image), title('Denoised Image');
%extracting start
idx=1;
embeding=imread('denoise_image.png');

extracted_image=embeding(1:392,1:392);
for i=1:8:392
  for j=1:8:392
    if(cases(idx)==2)
        for k=i:1:i+7
            for l=j:1:j+7
                extracted_image(k,l)=embeding(k,l)-1;
            end
        end
    end
    idx=idx+1;
  end
end

figure(5), imshow(extracted_image), title('Extracted Image');
diff_image=imabsdiff(img,extracted_image);
figure(6), imshow(diff_image), title('Difference Image');
imwrite(extracted_image,'extracted_image.png');
%Result = img==extracted_image; 

[PSNR_OUT,Z] = psnr(img,extracted_image);

ncc_arr = normxcorr2(img,extracted_image);
squaredErrorImage = (double(img) - double(extracted_image)) .^ 2;
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  It will be a scalar (a single number).
[rows, columns] = size(img);
clear sum;
aval = sum(sum(squaredErrorImage));
mse = aval/ (rows * columns);

disp('ModifiedMean Reconstructed Image');
str = sprintf('PSNR = %f',PSNR_OUT);

disp(str);

ncc = 0;
[rr, cc] = size(ncc_arr);
mx = max(max(ncc_arr));
for i=1:rr
    for j=1:cc
        ncc = ncc + ncc_arr(i,j);
    end
end
ncc = mx;

str = sprintf('NCC = %f',ncc);

disp(str);

str = sprintf('MSE = %f',mse);

disp(str);

somedata=[mse, PSNR_OUT, ncc];
somenames={'MSE', 'PSNR', 'NCC'};
figure(7),
title('Main vs Extracted'),
bar(somedata,'g'),
set(gca,'xticklabel',somenames);

V = zeros(N,N);
for mm = 1:N
    for nn = 1:N
        m = mm-1;
        n = nn-1;
        if n == 1
            V(mm,nn) = (N - m)/(N^2);
        else
            V(mm,nn) = ((N-m)*cos(m*n*pi/N)-csc(n*pi/N)*sin(m*n*pi/N))*(1/N^2);
        end
    end
end
vv = double(V);
im = img*(0.9999 + 0.01);
im = double(im);
Y = vv*im*vv';
X = im; %pinv(vv)*Y*(pinv(vv)');
X = uint8(255*mat2gray(X));
figure(8), imshow(extracted_image), title('After APDCBT Transform');


[PSNR_OUT,Z] = psnr(img,X);



ncc_arr = normxcorr2(img,X);
squaredErrorImage = (double(img) - double(X)) .^ 2;
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  It will be a scalar (a single number).
[rows, columns] = size(img);
clear sum;
aval = sum(sum(squaredErrorImage));
mse = aval/ (rows * columns);

disp('After ABDCBT Transformation and reconstrcution');
str = sprintf('PSNR = %f',PSNR_OUT);

disp(str);

ncc = 0;
[rr, cc] = size(ncc_arr);
mx = max(max(ncc_arr));
for i=1:rr
    for j=1:cc
        ncc = ncc + ncc_arr(i,j);
    end
end
ncc = mx;

str = sprintf('NCC = %f',ncc);

disp(str);

str = sprintf('MSE = %f',mse);

disp(str);


E = N*N*8;
A = N^2*(mx*pi);

C = 2*E - A;
C = C*inv(2*pi)/A;

str = sprintf('Embedding capacity = %f bpp',C);

disp(str);



somedata=[mse, PSNR_OUT, ncc, C];
somenames={'MSE', 'PSNR', 'NCC','Embedding Capacity'};
figure(9),
title('Main vs ABDCBT reconstructed'),
bar(somedata,'r'),
set(gca,'xticklabel',somenames);
 