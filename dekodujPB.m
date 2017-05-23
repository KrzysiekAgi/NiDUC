function [IsReceived, uncodedData] = dekodujPB( receivedPacket )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%   dekodowanie/kontrola b³êdów za pomoc¹ bitu parzystoœci

parityBit=recievedPacket(end)
recievedData=recievedPacket(1:end-1);
parityTest = mod(sum(recievedData),2)
if parityTest==parityBit
    IsRecieved = 1
  else
    IsRecieved = 0
  endif
 uncodedData=recievedData

end

