
function [bit]= sendBit(data, p)        %uproszona funkcja przesy³ania, przesy³a 1 bit, albo dobrze, alb go traci (wartoœæ 2), p równe p z BEC
  if rand(1,1)>p
    bit=data;
    else
    bit=2;
    endif
  end