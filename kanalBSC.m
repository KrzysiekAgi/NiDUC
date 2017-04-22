function [ corruptedData ] = kanalBSC( data, p )
%KANALBSC Summary of this function goes here
%   Detailed explanation goes here
%   data to macierz danych, p to prawdopodobieñstwo zak³ócenia
%   zak³adam, ¿e p<=0.5, inaczej nale¿y zrobiæ zamianê - odebrane 0
%   interpretujemy jako 1, a odebran¹ 1 jako 0. Wtedy p = 1 - p
    corruptedData = bsc(data, p);
end

