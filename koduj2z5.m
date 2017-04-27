function [codedData] = koduj2z5( data )
%KODUJ2Z5 Summary of this function goes here
%   Detailed explanation goes here


[m, n] = size(data);
codedData = zeros(m, n);

for i = 1:m
    for j = 1:n
        x = 5*(j-1) + 1;
        if data(i,j) == 0
            codedData(i, x:x+4) = [1, 1 , 0, 0, 0];
        else
            codedData(i, x:x+4) = [1, 0 , 1, 0, 0];
        end
    end
end 
end

