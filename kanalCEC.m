function [ corruptedData, BitsToNextError ] = kanalCEC( data, errorCycle, BitsToNextError )
%UNTITLED Summary of this function goes here
%   channel with cyclic errors
[m,n]=size(data);
corruptedData = zeros(m,n);
for i=1:n
  BitsToNextError = BitsToNextError - 1;
  if BitsToNextError == 0
      BitsToNextError = errorCycle;
      if data(i) == 1
          corruptedData(i) = 0;
      else
          corruptedData(i) = 1;
      end    
  else
      corruptedData(i) = data(i);
  end    
end

