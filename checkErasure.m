 function [info]=checkErasure(data)        %je�li wektor zawiera jak�� dw�jk�- zwraca 1
    [m,n]=size(data);
    info=0;
    for i=1:n
      if data(i)==2
        info=1;
      end
    end
end