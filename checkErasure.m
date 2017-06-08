 function [info]=checkErasure(data)        %jeœli wektor zawiera jak¹œ dwójkê- zwraca 1
    [m,n]=size(data);
    info=0;
    for i=1:n
      if data(i)==2
        info=1;
      end
    end
end