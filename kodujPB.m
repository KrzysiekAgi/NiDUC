function [codedData] = kodujPB( data )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%   kodowanie/kontrola b³êdów za pomoc¹ bitu parzystoœci

%pisane w Octavie, jeśli Matlab wywali syntax error, to pierwsze co sprawdźcie zmianę mod(sum(data),2) na sum(data) mod 2
  codedData = [data, mod(sum(data),2)];
end

