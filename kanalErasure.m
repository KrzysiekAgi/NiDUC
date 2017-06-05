function [corruptedData, info] = kanalErasure (data, p, result)
[m,n]=size(data); % tak de facto to jest to wektor (powstanie macierz o wymiarach coś x 1 )


for i=1:n
  if result(i)==2
    result(i)=sendBit(data(i),p);
    endif
endfor
   
corruptedData=result;   
info=checkErasure(corruptedData); 

end



function [bit]= sendBit(data, p)        %uproszona funkcja przesy�ania, przesy�a 1 bit, albo dobrze, alb go traci (warto�� 2), p r�wne p z BEC
  if rand(1,1)>p
    bit=data;
    else
    bit=2;
    endif
  end
    

 function [info]=checkErasure(data)
    [m,n]=size(data);
    info=0;
    for i=1:n
      if data(i)==2
        info=1;
     endif
     endfor
    end