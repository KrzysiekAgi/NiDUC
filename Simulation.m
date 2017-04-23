classdef Simulation < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ModelVer = 'BSC' % BSC(Binary Symetric Channel) or BEC(Binary Erasure Channel)
        ErrorControlVer = 'CRC32' % CRC32(Cyclic Redundancy Check) or 2z5(kod 2 z 5)
        ProtocolVer = 'SAN' % SAN(Stop-and-Wait) or GBN(Go-Back-N)
        PacketSize = 32 % Transfered Packet Size
        PacketsCount = 10 % Number of packets
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
        
        function setPacketsCount(obj,count) % setting Packets Count
            obj.PacketsCount = count;
        end
        
        function setBitTransRate(obj,speed) % setting bit transmission rate
            obj.BitTransmissionRate = speed;
        end
        
        function setErrorRate(obj,rate) % setting bit error probability
            obj.ErrorRate = rate;
        end
        
        function simulate(obj)
            % generowanie podzielonych pakietow i czasow przesylania
            WindowSizeGBN = 5; % !!!Placeholder value!!!
            PacketMatrix = generatePackets(obj.PacketsCount, obj.PacketSize);
            PacketTransferTime = obj.PacketSize/obj.BitTransmissionRate; % time in seconds
            TimeoutTime = PacketTransferTime * 5; % !!!Placeholder value!!!
            OperationTime = 0;
            
            PacketMatrixBeforeCoding = PacketMatrix;
            % kodowanie
            if strcmp(obj.ErrorControlVer,'CRC32')
               PacketMatrix = kodujcrc32(PacketMatrix);
            elseif strcmp(obj.ErrorControlVer,'2z5')
               PacketMatrix = koduj2z5(PacketMatrix);
            end
            
            RecievedPacketMatrix = []; % for later BER calculations
            if strcmp(obj.ProtocolVer,'SAW')
                % ------------STOP AND WAIT-----------
                for i=1:obj.PacketsCount % po kolei pakiety
                    IsRecieved = false;
                    while ~IsRecieved %notReceived
                        % przesylanie
                        if strcmp(obj.ModelVer,'BSC')  
                            recievedPacket = kanalBSC(PacketMatrix(i,:), obj.ErrorRate);
                        elseif strcmp(obj.ModelVer,'BEC')
                            recievedPacket = kanalErasure(PacketMatrix(i,:), obj.ErrorRate);
                        end
                        OperationTime = OperationTime + PacketTransferTime;
                        % odkodowanie/sprawdzenie
                        if strcmp(obj.ErrorControlVer,'CRC32')
                            [IsRecieved, Packet] = dekodujcrc32(recievedPacket);
                        elseif strcmp(obj.ErrorControlVer,'2z5')
                            [IsRecieved, Packet] = dekoduj2z5(recievedPacket);
                        end
                        
                        if ~IsRecieved
                            OperationTime = OperationTime + TimeoutTime;
                        end
                    end
                    % dodajemy pakiet do wynik
                    RecievedPacketMatrix = [RecievedPacketMatrix Packet]
                end
                RecievedPacketMatrix = vec2mat(RecievedPacketMatrix,obj.PacketSize);
            elseif strcmp(obj.ProtocolVer,'GBN')
                % -------------GO BACK N------------
                i = 1;
                while i < obj.PacketsCount
                    Responses = [];
                    PacketsRecieved = [];
                    
                    % setting smaller last window
                    if i+WindowSizeGBN > obj.PacketsCount
                        WindowSizeGBN = obj.PacketsCount - i; 
                    end
                    
                    % sending window size number of packets
                    for j=i:(i+WindowSizeGBN) 
                        % przesylanie
                        if strcmp(obj.ModelVer,'BSC')  
                            recievedPacket = kanalBSC(PacketMatrix(i,:), obj.ErrorRate);
                        elseif strcmp(obj.ModelVer,'BEC')
                            recievedPacket = kanalErasure(PacketMatrix(i,:), obj.ErrorRate);
                        end
                        OperationTime = OperationTime + PacketTransferTime;
                        % odkodowanie
                        if strcmp(obj.ErrorControlVer,'CRC32')
                            [IsRecieved, Packet] = dekodujcrc32(recievedPacket);
                        elseif strcmp(obj.ErrorControlVer,'2z5')
                            [IsRecieved, Packet] = dekoduj2z5(recievedPacket);
                        end
                        Responses = [Responses IsRecieved];
                        PacketsRecieved = [PacketsRecieved Packet];
                    end
                    PacketsRecieved = vec2mat(PacketsRecieved,obj.PacketSize);
                    for j=1:WindowSizeGBN % managing responses / moving window
                        if Responses(j)
                            RecievedPacketMatrix = [RecievedPacketMatrix PacketsRecieved(j,:)];
                            i = i + 1;
                        else
                            OperationTime = OperationTime + TimeoutTime;
                            break;
                        end
                    end
                end
            end
            % -------------------------
            % porównanie
            [number, ratio] = biterr(PacketMatrixBeforeCoding, RecievedPacketMatrix);
        end
    end
    
end

