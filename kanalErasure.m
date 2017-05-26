function [corruptedData] = kanalErasure (data, p)
[m,n]=size(data); % tak de facto to jest to wektor (powstanie macierz o wymiarach coś x 1 )
j=1;
   for i=1:(n*m)
     if rand(1,1)>p
      corruptedData(j)=data(i);
      j = j + 1;
     else
     end
   end
   
end
