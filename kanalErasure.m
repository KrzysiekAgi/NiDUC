function [corruptedData] = kanalErasure (data, p)
[m,n]=size(data);
j=1;
   for i=1:n
     if rand(1,1)>p
      corruptedData(j)=data(i);
      j++;
     else
      endif
   endfor
    
endfunction
