classdef Simulation < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ModelVer = 'BSC' % BSC(Binary Symetric Channel) or BEC(Binary Erasure Channel)
        ErrorControlVer = 'CRC32' % CRC32(Cyclic Redundancy Check) or 2z5(kod 2 z 5)
        ProtocolVer = 'SAN' % SAN(Stop-and-Wait) or GBN(Go-Back-N)
        PacketSize = 32 % Transfered Packet Size
        BitTransmissionRate = 1000 % Bit transmission rate for time calculations
        ErrorRate = 0.1 % Probability of bit error value <0.0,0.5>
    end
    
    methods
        function setModelVer(obj,ver) % changing between Model Versions
            obj.ModelVer = ver;
        end
        
        function setErrorControlVer(obj,ver) % changing between Error Control Versions
            obj.ErrorControlVer = ver;
        end
        
        function setProtocolVer(obj,ver) % changing ARQ Protocol Versions
            obj.ProtocolVer = ver;
        end
        
        function setPacketSize(obj,size) % changing transfered Packet Size
            obj.PacketSize = size;
        end
        
        function setBitTransRate(obj,speed) % setting bit transmission rate
            obj.BitTransmissionRate = speed;
        end
        
        function setErrorRate(obj,rate) % setting bit error probability
            obj.ErrorRate = rate;
        end
        
        function simulate(obj)
            % generowanie podzielonych pakietow
            PacketsCount = 10; % Placeholder value
            PacketMatrix = generatePackets(PacketsCount, obj.PacketSize);
            PacketTransferTime = obj.PacketSize/obj.BitTransmissionRate; % time in seconds
            TimeoutTime = PacketTrasnferTime * 5;
            OperationTime = 0;
            
            % kodowanie
            if obj.ErrorControlVer == 'CRC32'
               kodujcrc32(PacketMatrix);
            elseif obj.ErrorControlVer == '2z5'
               koduj2z5(PacketMatrix);
            end
            
            RecievedPacketMatrix = []; % for later BER calculations
            if obj.ProtocolVer == 'SAW'
                % ------------STOP AND WAIT-----------
                for i=1:PacketsCount % po kolei pakiety
                    IsRecieved = false;
                    while ~IsRecieved %notReceived
                        % przesylanie
                        if ModelVer == 'BSC'  
                            recievedPacket = kanalBSC(PacketMatrix(i,:));
                        elseif ModelVer == 'BEC'
                            recievedPacket = kanalErasure(PacketMatrix(i,:));
                        end
                        OperationTime = OperationTime + PacketTransferTime;
                        % odkodowanie/sprawdzenie
                        [IsRecieved, Packet] = dekoduj2z5(recievedPacket);
                        [IsRecieved, Packet] = dekodujcrc32(recievedPacket);
                        if ~IsRecieved
                            OperationTime = OperationTime + TimeoutTime;
                        end
                    end
                    % dodajemy pakiet do wynik
                    RecievedPacketMatrix = [RecievedPacketMatrix Packet]
                end
            elseif obj.ProtocolVer == 'GBN'
                % -------------GO BACK N------------
                for i=1:1% po kolei pakiety
                    while 1 %notReceived
                        % przesylanie
                        recievedPacket = kanalBSC(PacketMatrix(i,:));
                        recievedPacket = kanalErasure(PacketMatrix(i,:));
                        % odkodowanie/sprawdzenie
                        dekoduj2z5();
                        dekodujcrc32();
                    end
                    % dodajemy pakiet do wynik
                end
            end
            % -------------------------
            % porównanie
        end
    end
    
end

