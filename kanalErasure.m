function [corruptedData, info] = kanalErasure (data, p, result)
[m,n]=size(data); % tak de facto to jest to wektor (powstanie macierz o wymiarach coÅ› x 1 )


for i=1:n                               %result to "aktualny" stan otrzymanego pakietu
  if result(i)==2                       %wszystkie 2 w resulcie s¹ przesy³ane ponownie
    result(i)=sendBit(data(i),p);
  end
end
   
corruptedData=result;                   %nowy result jest zwracany
info=checkErasure(corruptedData);       %plus informacja czy s¹ w nim jeszcze jakieœ dwójki

end

    

