function B = dctver2(A)
   % Reference : http://matlab.izmiran.ru/help/toolbox/images/transfo5.html
   % Author : Zabir Al Nazi
   % Email : zabiralnazi@codeassign.com
   [M, N, z] = size(A);
   if(z ~= 1)
       disp('Implemented for single channel image\n');
   end
   A = double(A);
   B = zeros(M,N);
   
   for p = 1:M
       for q = 1:N
           if p == 1
               ap = sqrt(1/M);
           else
               ap = sqrt((2/M));
           end
           
           if q == 1
               aq = sqrt(1/N);
           else
               aq = sqrt((2/N));
           end
           
           
           
           res = 0.00;
           
           for m = 1:M
               for n = 1:N
                   mm = m-1; %-1;
                   nn = n-1; %-1;
                   pp = p-1; %-1;
                   qq = q-1; %-1;
                   test = A(m,n)*cos((pi*(2*mm+1)*pp/(2*M)))...
                       *cos((pi*(2*nn+1)*qq/(2*N)));
                   res = res + test;
               end
           end
           
           B(p,q) = ap*aq*res;
           
           
           
       end
       
   end
           
end