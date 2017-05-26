function [codedData] = kodujPB( data )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%   kodowanie/kontrola bledow za pomoca bitu parzystosci

  [m,n] = size(data);
  codedData = zeros(m, n+1);
  for i = 1:m
      codedData(i,1:n) = data(i,1:n);
      codedData(i,n+1) = mod(sum(data(i,1:n)),2);
  end
end

