
function [bit]= sendBit(data, p)        %uproszona funkcja przesy�ania, przesy�a 1 bit, albo dobrze, alb go traci (warto�� 2), p r�wne p z BEC
  if rand(1,1)>p
    bit=data;
    else
    bit=2;
    endif
  end