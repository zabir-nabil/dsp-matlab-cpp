clc;
close all;
clear all;

%--------tent map-----------
u = 1.99;
    N = 25599;
    t(1)=0.5;

    for iii=1:N
        if t(iii) < 0.5 %and condition
            t(iii+1)=u*t(iii); %is it right
        else
            if t(iii) >= 0.5 %and this condition 
            t(iii+1)=u*(1-t(iii)); %is it right
            end
        end
    end
Z = reshape(t,[],160);
t=round(Z);
%t=imresize(y, [160 160]);
figure, 
imshow(t, []);
title('tent');

s=imread('Black-A-Z-Letters-Light-15cm-6-Letter-LED-Marquee-Sign-Alphabet-Light-Lamp-Indoor-Wall.jpg');
p=imresize(s, [160 160]);
B = im2bw(p, 0.5);
figure, 
imshow(B, []);
title('input1');
C=xor(B,t);%watermark 1
figure, 
imshow(C, []);
title('Watermark 1');


f= imread('124162858.jpg');
g=imresize(f, [160 160]);
h = im2bw(g, 0.5);
figure, 
imshow(h, []);
title('input2');
J=xor(h,t); %watermark 2
figure, 
imshow(J, []);
title('Watermark 2');


%--------host image input and iwt -----
img = imread('cameraman.tif'); % Read image
im= imresize(img, [1600 1600]);
imgg=double(im);

I=imgg;
[CA1,CH1,CV1,CD1]=lwt2(I,'haar');
z=[CA1,CH1,CV1,CD1];


InputImage=CA1;
LOW=CA1;
M=size(InputImage,1);
N=size(InputImage,2);
d=1;
a=1;
b=1;
aa=1;
bb=1;
for i=3:5:M
    for j=3:5:N
        if (InputImage(i-1,j-1)>InputImage(i,j))
            InputImage(i-1,j-1)=1;
        else
            InputImage(i-1,j-1)=0;
        end

        if (InputImage(i-1,j)>InputImage(i,j))
            InputImage(i-1,j)=1;
        else
            InputImage(i-1,j)=0;
        end

        if (InputImage(i-1,j+1)>InputImage(i,j))
            InputImage(i-1,j+1)=1;
        else
            InputImage(i-1,j+1)=0;
        end

        if (InputImage(i,j-1)>InputImage(i,j))
            InputImage(i,j-1)=1;
        else
            InputImage(i,j-1)=0;
        end

        if (InputImage(i,j+1)>InputImage(i,j))
            InputImage(i,j+1)=1;
        else
            InputImage(i,j+1)=0;
        end

        if (InputImage(i+1,j-1)>InputImage(i,j))
            InputImage(i+1,j-1)=1;
        else
            InputImage(i+1,j-1)=0;
        end

        if (InputImage(i+1,j)>InputImage(i,j))
            InputImage(i+1,j)=1;
        else
            InputImage(i+1,j)=0;
        end

        if (InputImage(i+1,j+1)>InputImage(i,j))
            InputImage(i+1,j+1)=1;
        else
            InputImage(i+1,j+1)=0;
        end
        
        %for excess mask
        if (InputImage(i-2,j-2)>InputImage(i,j))
            InputImage(i-2,j-2)=1;
        else
            InputImage(i-2,j-2)=0;
        end
        if (InputImage(i-2,j-1)>InputImage(i,j))
            InputImage(i-2,j-1)=1;
        else
            InputImage(i-2,j-1)=0;
        end
        if (InputImage(i-2,j)>InputImage(i,j))
            InputImage(i-2,j)=1;
        else
            InputImage(i-2,j)=0;
        end
        if (InputImage(i-2,j+1)>InputImage(i,j))
            InputImage(i-2,j+1)=1;
        else
            InputImage(i-2,j+1)=0;
        end
        if (InputImage(i-2,j+2)>InputImage(i,j))
            InputImage(i-2,j+2)=1;
        else
            InputImage(i-2,j+2)=0;
        end
        if (InputImage(i-1,j-2)>InputImage(i,j))
            InputImage(i-1,j-2)=1;
        else
            InputImage(i-1,j-2)=0;
        end
        if (InputImage(i-1,j+2)>InputImage(i,j))
            InputImage(i-1,j+2)=1;
        else
            InputImage(i-1,j+2)=0;
        end
        if (InputImage(i,j-2)>InputImage(i,j))
            InputImage(i,j-2)=1;
        else
            InputImage(i,j-2)=0;
        end
        if (InputImage(i,j+2)>InputImage(i,j))
            InputImage(i,j+2)=1;
        else
            InputImage(i,j+2)=0;
        end
        if (InputImage(i+1,j-2)>InputImage(i,j))
            InputImage(i+1,j-2)=1;
        else
            InputImage(i+1,j-2)=0;
        end
        if (InputImage(i+1,j+2)>InputImage(i,j))
            InputImage(i+1,j+2)=1;
        else
            InputImage(i+1,j+2)=0;
        end
        if (InputImage(i+2,j-2)>InputImage(i,j))
            InputImage(i+2,j-2)=1;
        else
            InputImage(i+2,j-2)=0;
        end
        if (InputImage(i+2,j-1)>InputImage(i,j))
            InputImage(i+2,j-1)=1;
        else
            InputImage(i+2,j-1)=0;
        end
        if (InputImage(i+2,j)>InputImage(i,j))
            InputImage(i+2,j)=1;
        else
            InputImage(i+2,j)=0;
        end
        if (InputImage(i+2,j+1)>InputImage(i,j))
            InputImage(i+2,j+1)=1;
        else
            InputImage(i+2,j+1)=0;
        end
        if (InputImage(i+2,j+2)>InputImage(i,j))
            InputImage(i+2,j+2)=1;
        else
            InputImage(i+2,j+2)=0;
        end
    

   %odd-----
       q_1=xor(InputImage(i-2,j-2),InputImage(i-2,j));
       q_2=xor(q_1,InputImage(i-2,j+2));
       q_3=xor(q_2,InputImage(i-1,j-1));
       q_4=xor(q_3,InputImage(i-1,j+1));
       q_5=xor(q_4,InputImage(i,j-2));
       q_6=xor(q_5,InputImage(i,j+2));
       q_7=xor(q_6,InputImage(i+1,j-1));
       q_8=xor(q_7,InputImage(i+1,j+1));
       q_9=xor(q_8,InputImage(i+2,j-2));
       q_10=xor(q_9,InputImage(i+2,j));
       o(d)=xor(q_10,InputImage(i+2,j+2));
   
       
   
       if a<=160 && b<=160
             if  o(d)==C(aa,bb)
                bb=bb+1;
                if bb>160
                    bb=1;
                    aa=a+1;
                end
             else
                 if CA1(i-1,j+1) > CA1(i,j)
                    CA1(i-1,j+1)= CA1(i,j)-1;
                    bb=bb+1;
                    
                      if bb>160
                           bb=1;
                           aa=aa+1;
                      end
                 else
                     CA1(i-1,j+1)= CA1(i,j)+1;
                      bb=bb+1;
                      
                      if bb>160
                           bb=1;
                           aa=aa+1;
                      end
                 end
             end
       end
   %even


       c_1=xor(InputImage(i-2,j-1),InputImage(i-2,j+1));
       c_2=xor(c_1,InputImage(i-1,j-2));
       c_3=xor(c_2,InputImage(i-1,j));
       c_4=xor(c_3,InputImage(i-1,j+2));
       c_5=xor(c_4,InputImage(i,j-1));
       c_6=xor(c_5,InputImage(i,j+1));
       c_7=xor(c_6,InputImage(i+1,j-2));
       c_8=xor(c_7,InputImage(i+1,j));
       c_9=xor(c_8,InputImage(i+1,j+2));
       c_10=xor(c_9,InputImage(i+2,j-1));
       v(d)=xor(c_10,InputImage(i+2,j+1));
       
       if a<=160 && b<=160
             if  v(d)==J(a,b)
                b=b+1;
                
                if b>160
                    b=1;
                    a=a+1;
                end
             else
                 if CA1(i-1,j) >  CA1(i,j)
                    CA1(i-1,j)= CA1(i,j)-1;
                    b=b+1;
                  
                      if b>160
                           b=1;
                           a=a+1;
                      end
                 else
                     CA1(i-1,j)= CA1(i,j)+1;
                      b=b+1;
                      
                      if b>160
                           b=1;
                           a=a+1;
                      end
                 end
             end
       end
   
       d=d+1;
    end
end

k=1;
for i=1:160
    for j=1:160
        if LOW(i,j)==CA1(i,j)
            k=k+1;
        end
    end
end
        
IW=ilwt2(CA1,CH1,CV1,CD1,'haar');
Is=uint8(IW);
IW=double(IW);
figure, imshow(Is);
title('embedded');

%------------------psnr-----------------
error = imgg-IW;
d1=max(imgg(:));
d2=max(IW(:));
d=max(d1,d2);
MSE = sum(sum(error .^2)) / (1600*1600)
PSNR = 10*log10(d.^2/MSE)


% imwrite(Is,'aa4.png','png');






%Extracting
% I=IW;

input_im=imread('bb4.png');
i_im=imresize(input_im, [1600 1600]);
figure, imshow(i_im);
title('cropped image');
I=double(i_im);

[CA1,CH1,CV1,CD1]=lwt2(I,'haar');
z=[CA1,CH1,CV1,CD1];

%-------LBP-------
InputImage=CA1;
LOW=CA1;
M=size(InputImage,1);
N=size(InputImage,2);
xx=1;
yy=1;
mm=1;
x=1;
y=1;
m=1;
for i=3:5:M
    for j=3:5:N
        
        if (InputImage(i-1,j-1)>InputImage(i,j))
            InputImage(i-1,j-1)=1;
        else
            InputImage(i-1,j-1)=0;
        end

        if (InputImage(i-1,j)>InputImage(i,j))
            InputImage(i-1,j)=1;
        else
            InputImage(i-1,j)=0;
        end

        if (InputImage(i-1,j+1)>InputImage(i,j))
            InputImage(i-1,j+1)=1;
        else
            InputImage(i-1,j+1)=0;
        end

        if (InputImage(i,j-1)>InputImage(i,j))
            InputImage(i,j-1)=1;
        else
            InputImage(i,j-1)=0;
        end

        if (InputImage(i,j+1)>InputImage(i,j))
            InputImage(i,j+1)=1;
        else
            InputImage(i,j+1)=0;
        end

        if (InputImage(i+1,j-1)>InputImage(i,j))
            InputImage(i+1,j-1)=1;
        else
            InputImage(i+1,j-1)=0;
        end

        if (InputImage(i+1,j)>InputImage(i,j))
            InputImage(i+1,j)=1;
        else
            InputImage(i+1,j)=0;
        end

        if (InputImage(i+1,j+1)>InputImage(i,j))
            InputImage(i+1,j+1)=1;
        else
            InputImage(i+1,j+1)=0;
        end
        %for excess mask
        if (InputImage(i-2,j-2)>InputImage(i,j))
            InputImage(i-2,j-2)=1;
        else
            InputImage(i-2,j-2)=0;
        end
        if (InputImage(i-2,j-1)>InputImage(i,j))
            InputImage(i-2,j-1)=1;
        else
            InputImage(i-2,j-1)=0;
        end
        if (InputImage(i-2,j)>InputImage(i,j))
            InputImage(i-2,j)=1;
        else
            InputImage(i-2,j)=0;
        end
        if (InputImage(i-2,j+1)>InputImage(i,j))
            InputImage(i-2,j+1)=1;
        else
            InputImage(i-2,j+1)=0;
        end
        if (InputImage(i-2,j+2)>InputImage(i,j))
            InputImage(i-2,j+2)=1;
        else
            InputImage(i-2,j+2)=0;
        end
        if (InputImage(i-1,j-2)>InputImage(i,j))
            InputImage(i-1,j-2)=1;
        else
            InputImage(i-1,j-2)=0;
        end
        if (InputImage(i-1,j+2)>InputImage(i,j))
            InputImage(i-1,j+2)=1;
        else
            InputImage(i-1,j+2)=0;
        end
        if (InputImage(i,j-2)>InputImage(i,j))
            InputImage(i,j-2)=1;
        else
            InputImage(i,j-2)=0;
        end
        if (InputImage(i,j+2)>InputImage(i,j))
            InputImage(i,j+2)=1;
        else
            InputImage(i,j+2)=0;
        end
        if (InputImage(i+1,j-2)>InputImage(i,j))
            InputImage(i+1,j-2)=1;
        else
            InputImage(i+1,j-2)=0;
        end
        if (InputImage(i+1,j+2)>InputImage(i,j))
            InputImage(i+1,j+2)=1;
        else
            InputImage(i+1,j+2)=0;
        end
        if (InputImage(i+2,j-2)>InputImage(i,j))
            InputImage(i+2,j-2)=1;
        else
            InputImage(i+2,j-2)=0;
        end
        if (InputImage(i+2,j-1)>InputImage(i,j))
            InputImage(i+2,j-1)=1;
        else
            InputImage(i+2,j-1)=0;
        end
        if (InputImage(i+2,j)>InputImage(i,j))
            InputImage(i+2,j)=1;
        else
            InputImage(i+2,j)=0;
        end
        if (InputImage(i+2,j+1)>InputImage(i,j))
            InputImage(i+2,j+1)=1;
        else
            InputImage(i+2,j+1)=0;
        end
        if (InputImage(i+2,j+2)>InputImage(i,j))
            InputImage(i+2,j+2)=1;
        else
            InputImage(i+2,j+2)=0;
        end
        %excess mask

       q_1=xor(InputImage(i-2,j-2),InputImage(i-2,j));
       q_2=xor(q_1,InputImage(i-2,j+2));
       q_3=xor(q_2,InputImage(i-1,j-1));
       q_4=xor(q_3,InputImage(i-1,j+1));
       q_5=xor(q_4,InputImage(i,j-2));
       q_6=xor(q_5,InputImage(i,j+2));
       q_7=xor(q_6,InputImage(i+1,j-1));
       q_8=xor(q_7,InputImage(i+1,j+1));
       q_9=xor(q_8,InputImage(i+2,j-2));
       q_10=xor(q_9,InputImage(i+2,j));
       O(mm)=xor(q_10,InputImage(i+2,j+2));
       if xx<=160 && yy<=160
         if O(mm)==1
             W(xx,yy)=1;
             yy=yy+1;
             mm=mm+1;
             if yy>160
                 yy=1;
                 xx=xx+1;
             end
         else
             W(xx,yy)=0;
             yy=yy+1;
             mm=mm+1;
             if yy>160
                 yy=1;
                 xx=xx+1;
             end
         end
         end
       
       

       c_1=xor(InputImage(i-2,j-1),InputImage(i-2,j+1));
       c_2=xor(c_1,InputImage(i-1,j-2));
       c_3=xor(c_2,InputImage(i-1,j));
       c_4=xor(c_3,InputImage(i-1,j+2));
       c_5=xor(c_4,InputImage(i,j-1));
       c_6=xor(c_5,InputImage(i,j+1));
       c_7=xor(c_6,InputImage(i+1,j-2));
       c_8=xor(c_7,InputImage(i+1,j));
       c_9=xor(c_8,InputImage(i+1,j+2));
       c_10=xor(c_9,InputImage(i+2,j-1));
       V(m)=xor(c_10,InputImage(i+2,j+1));
         if x<=160 && y<=160
         if V(m)==1
             W2(x,y)=1;
             y=y+1;
             m=m+1;
             if y>160
                 y=1;
                 x=x+1;
             end
         else
             W2(x,y)=0;
             y=y+1;
             m=m+1;
             if y>160
                 y=1;
                 x=x+1;
             end
         end
         end
       
             
    end
end
F=xor(W,t);
figure, imshow(F);
T=xor(W2,t);
figure,
imshow(T);

%-------------------ncc-------------------
wss=double(T);
wmm=double(h);       
nc=sum(sum(wmm.*wss))/sum(sum(wmm.*wmm))   

