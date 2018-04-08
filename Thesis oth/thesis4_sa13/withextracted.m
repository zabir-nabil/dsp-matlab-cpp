img=imread('lena.png');
%imshow(img);
figure(1), imshow(img), title('Main Image');
embeding=img(1:392,1:392);
%imshow(embeding);
alpha=zeros(1,2401);
cases=zeros(1,2401);
idx=1;
disp(idx);
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
 
 
 %extracting start

idx=1;
embeding=imread('embeded_image.png');
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

%imshow(extracted_image);
figure(3), imshow(extracted_image), title('Extracted Image');

imwrite(extracted_image,'extracted_image.png');

img=img(1:392,1:392);
Result = img==extracted_image; 
 
[PSNR_OUT,Z] = psnr(img,extracted_image);

squaredErrorImage = (double(img) - double(extracted_image)) .^ 2;
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  It will be a scalar (a single number).
[rows, columns] = size(img);
clear sum;
aval = sum(sum(squaredErrorImage));
mse = aval/ (rows * columns);

disp('Reconstructed Image');
str = sprintf('PSNR = %f',PSNR_OUT);

disp(str);

str = sprintf('MSE = %f',mse);

disp(str);

if PSNR_OUT == Inf
    PSNR_OUT = 500000; % quantization bounding
end

somedata=[mse, PSNR_OUT];
somenames={'MSE', 'PSNR'};
figure(7),
title('Main vs Extracted'),
bar(somedata,'g'),
set(gca,'xticklabel',somenames);