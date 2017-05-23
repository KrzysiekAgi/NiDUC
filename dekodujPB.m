function [IsReceived, uncodedData] = dekodujPB( receivedPacket )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%   dekodowanie/kontrola b³êdów za pomoc¹ bitu parzystoœci

parityBit=receivedPacket(end);
receivedData=receivedPacket(1:end-1);
parityTest = mod(sum(receivedData),2);
if parityTest==parityBit
    IsReceived = 1;
else
    IsReceived = 0;
end
uncodedData=receivedData;

end

