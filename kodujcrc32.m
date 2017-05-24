function [ codedData ] = kodujcrc32( data )
%KODUJCRC32 Summary of this function goes here

[m,n] = size(data);
poly = [1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];
codedData = zeros(m,n+32);
for i=1:m
    codedData(i,1:n) = data(i,:);
    manipulatedData = [data(i,:) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    for j=1:n
        if manipulatedData(j)
            manipulatedData(1,j:j+32) = bitxor(manipulatedData(1,j:j+32),poly);
        end
    end
    codedData(i,n+1:n+32) = manipulatedData(1,n+1:n+32);
end

codedData = vec2mat(codedData,n+32);
end

