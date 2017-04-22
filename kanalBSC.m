function [ corruptedData ] = kanalBSC( data, p )
%KANALBSC Summary of this function goes here
%   Detailed explanation goes here
%   data to macierz danych, p to prawdopodobie�stwo zak��cenia
%   zak�adam, �e p<=0.5, inaczej nale�y zrobi� zamian� - odebrane 0
%   interpretujemy jako 1, a odebran� 1 jako 0. Wtedy p = 1 - p
    corruptedData = bsc(data, p)
end

