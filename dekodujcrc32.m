function [IsValid, uncodedData] = dekodujcrc32( data )
%DEKODUJCRC32 Summary of this function goes here
%   Detailed explanation goes here
[~,n] = size(data);
poly = [1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1];
uncodedData = data(1,1:n-32);
manipulatedData = [uncodedData 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
for i=1:n-32
    if manipulatedData(i) == 1
        manipulatedData(1,i:i+32) = bitxor(manipulatedData(1,i:i+32), poly);
    end
end
if manipulatedData(1,n-31:n) == data(1,n-31:n)
    IsValid = 1;
else
    IsValid = 0;
end

end

