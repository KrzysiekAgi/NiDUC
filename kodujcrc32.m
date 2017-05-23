function [ codedData ] = kodujcrc32( data )
%KODUJCRC32 Summary of this function goes here

[m n] = size(data);
poly = [1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];
codedData = [];
for i=1:m
    codedData = [codedData data(i,:)];
    manipulatedData = [data(i,:) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    for j=1:n
        if manipulatedData(j)
            manipulatedData(1,j:j+32) = bitxor(manipulatedData(1,j:j+32),poly);
        end
    end
    codedData = [codedData manipulatedData(1,n+1:n+32)];
end

codedData = vec2mat(codedData,n+32);
end

