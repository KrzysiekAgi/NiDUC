function [corruptedData] = kanalErasure (data, p)
[m,n]=size(data); % tak de facto to jest to wektor (powstanie macierz o wymiarach cos x 1 )
j=1;
counter=0;        %licznik ponownie przes³anych bitów
erased=0;         %macierz indeksów utraconych bitów
k=1;
   for i=1:(n*m)  
     if rand(1,1)>p
      corruptedData(j)=data(i);
      j = j + 1;
     else
     corruptedData(j)=2;
     j=j+1;
    erased(k)=j-1;
   k=k+1; 
     endif
   endfor           %koniec tworzenia macierzy uzyskanej z BEC i macierzy indeksów utraconych bitów
[a,b]=size(erased); 
if erased~=0         %jeœli jakieœ bity by³y utracone przesy³amy je ponownie uproszczon¹ funkcj¹
k=1; 
   for k=1:b
     while corruptedData(erased(k))==2            %przesy³anie bitu a¿ do uzyskania poprawnej jego wartoœci
      corruptedData(erased(k))=(resendBit(data(erased(k)),p));
      counter=counter+1;
      endwhile
     endfor
 endif    
   
   
   
   corruptedData(j)=counter;      %licznik ponownych przes³añ bitów na koniec macierzy wynikowej

end



function [bit]= resendBit(data, p)        %uproszona funkcja przesy³ania, przesy³a 1 bit, albo dobrze, alb go traci (wartoœæ 2), p równe p z BEC
  if rand(1,1)>p
    bit=data;
    else
    bit=2;
    endif
  end
    