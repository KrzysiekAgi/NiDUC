function [codedData] = koduj2z5( data )
%KODUJ2Z5 Summary of this function goes here
%   Detailed explanation goes here

codedData = [];

for i = 1:size(data,1)
    v = [];
    for j = 1:size(data,2)
        if data(i,j) == 0
            v = [v 1 1 0 0 0];
        else
            v = [v 1 0 1 0 0];
        end
    end
    codedData = [codedData;v];
end 
end

