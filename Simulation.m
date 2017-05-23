classdef Simulation < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ModelVer = 'BSC' % BSC(Symetric) or BEC(Erasure) or CEC (Cyclic Error Channel)
        ErrorControlVer = 'CRC32' % CRC32(Cyclic Redundancy Check) or 2z5(kod 2 z 5)
        ProtocolVer = 'SAW' % SAW(Stop-and-Wait) or GBN(Go-Back-N)
        PacketSize = 32 % Transfered Packet Size
        PacketsCount = 10 % Number of packets
        BitTransmissionRate = 1000 % Bit transmission rate for time calculations
        ErrorRate = 0.002 % Probability of bit error value <0.0,0.5>
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
            WindowSizeGBN = 20; % !!!Placeholder value!!!
            PacketMatrix = generatePackets(obj.PacketsCount, obj.PacketSize);
            PacketTransferTime = obj.PacketSize/obj.BitTransmissionRate; % time in seconds
            TimeoutTime = PacketTransferTime * 10; % !!!Placeholder value!!!
            OperationTime = 0;
            ResendPackageCounter = 0;
            
            PacketMatrixBeforeCoding = PacketMatrix;
            % kodowanie
            if strcmp(obj.ErrorControlVer,'CRC32')
               PacketMatrix = kodujcrc32(PacketMatrix);
            elseif strcmp(obj.ErrorControlVer,'2z5')
               PacketMatrix = koduj2z5(PacketMatrix);
            end
            
            ReceivedPacketMatrix = zeros(1,obj.PacketSize*obj.PacketsCount); % for later BER calculations
            if strcmp(obj.ProtocolVer,'SAW')
                % ------------STOP AND WAIT-----------
                for i=1:obj.PacketsCount % po kolei pakiety
                    IsReceived = false;
                    while ~IsReceived %notReceived
                        % przesylanie
                        if strcmp(obj.ModelVer,'BSC')  
                            receivedPacket = kanalBSC(PacketMatrix(i,:), obj.ErrorRate);
                        elseif strcmp(obj.ModelVer,'BEC')
                            receivedPacket = kanalErasure(PacketMatrix(i,:), obj.ErrorRate);
                        elseif strcmp(obj.ModelVer, 'CEC')
                            receivedPacket = kanalCEC(PacketMatrix(i,:), obj.ErrorRate);
                        end
                        OperationTime = OperationTime + PacketTransferTime;
                        % odkodowanie/sprawdzenie
                        if strcmp(obj.ErrorControlVer,'CRC32')
                            [IsReceived, Packet] = dekodujcrc32(receivedPacket);
                        elseif strcmp(obj.ErrorControlVer,'2z5')
                            [IsReceived, Packet] = dekoduj2z5(receivedPacket);
                        end
                        
                        if ~IsReceived
                            OperationTime = OperationTime + TimeoutTime;
                            ResendPackageCounter = ResendPackageCounter + 1;
                        end
                    end
                    % dodajemy pakiet do wynik
                    ReceivedPacketMatrix(1,(((i-1)*obj.PacketSize)+1):((i*obj.PacketSize))) = Packet;
                end
            elseif strcmp(obj.ProtocolVer,'GBN')
                % -------------GO BACK N------------
                i = 1;
                while i <= obj.PacketsCount
                    Responses = zeros(1,WindowSizeGBN);
                    PacketsRecieved = [];
                    
                    % setting smaller last window
                    if i+WindowSizeGBN-1 > obj.PacketsCount
                        WindowSizeGBN = (obj.PacketsCount - i)+1; 
                    end
                    
                    % sending window size number of packets
                    WindowStep = 1;
                    for j=i:(i+WindowSizeGBN-1) 
                        % przesylanie
                        if strcmp(obj.ModelVer,'BSC')  
                            receivedPacket = kanalBSC(PacketMatrix(j,:), obj.ErrorRate);
                        elseif strcmp(obj.ModelVer,'BEC')
                            receivedPacket = kanalErasure(PacketMatrix(j,:), obj.ErrorRate);
                        elseif strcmp(obj.ModelVer, 'CEC')
                            receivedPacket = kanalCEC(PacketMatrix(j,:), obj.ErrorRate);    
                        end
                        OperationTime = OperationTime + PacketTransferTime;
                        % odkodowanie
                        if strcmp(obj.ErrorControlVer,'CRC32')
                            [IsReceived, Packet] = dekodujcrc32(receivedPacket);
                        elseif strcmp(obj.ErrorControlVer,'2z5')
                            [IsReceived, Packet] = dekoduj2z5(receivedPacket);
                        end
                        Responses(1,WindowStep) = IsReceived;
                        PacketsRecieved(1,(((WindowStep-1)*obj.PacketSize)+1):((WindowStep*obj.PacketSize))) = Packet;
                        WindowStep = WindowStep + 1;
                    end
                    PacketsRecieved = vec2mat(PacketsRecieved,obj.PacketSize);
                    for j=1:WindowSizeGBN % managing responses / moving window
                        if Responses(j)
                            ReceivedPacketMatrix(1,(((i-1)*obj.PacketSize)+1):((i*obj.PacketSize))) = PacketsRecieved(j,:);
                            i = i + 1;
                        else
                            OperationTime = OperationTime + TimeoutTime;
                            ResendPackageCounter = ResendPackageCounter + 1;
                            break;
                        end
                    end
                end
            end
            % -------------------------
            % porównanie
            ReceivedPacketMatrix = vec2mat(ReceivedPacketMatrix,obj.PacketSize);
            [number, ratio] = biterr(PacketMatrixBeforeCoding, ReceivedPacketMatrix)
            OperationTime
            ResendPackageCounter
            % zapis parametrów i wyników do pliku
            fileID = fopen('data.txt','a');
            format = '%s;%s;%s;%d;%d;%d;%f;%f;%f;%d';
            fprintf(fileID, format, obj.ModelVer, obj.ErrorControlVer,obj.ProtocolVer, obj.PacketSize, obj.PacketsCount, obj.BitTransmissionRate, obj.ErrorRate, ratio, OperationTime, ResendPackageCounter);
            fclose(fileID);
        end
    end
    
end

