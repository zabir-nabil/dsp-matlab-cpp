function A = idctver2(B)
   % Reference : http://matlab.izmiran.ru/help/toolbox/images/transfo5.html
   [M, N] = size(B);
   B = double(B);
   A = zeros(M,N);
   
   for m = 1:M
       for n = 1:N
           
           
           
           res = 0.00;
           
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
           
                   mm = m-1; %-1;
                   nn = n-1; %-1;
                   pp = p-1; %-1;
                   qq = q-1; %-1;
                   test = ap*aq*B(p,q)*cos((pi*(2*mm+1)*pp/(2*M)))...
                       *cos((pi*(2*nn+1)*qq/(2*N)));
                   res = res + test;
               end
           end
           
           A(m,n) = res;
           
           
           
       end
       
   end
           
end