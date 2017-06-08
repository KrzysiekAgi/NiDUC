classdef Simulation < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ModelVer = 'BSC' % BSC(Symetric) or BEC(Erasure) or CEC (Cyclic Error Channel)
        ErrorControlVer = 'CRC32' % CRC32(Cyclic Redundancy Check) or 2z5(kod 2 z 5) or PB(Parity Bit)
        ProtocolVer = 'SAW' % SAW(Stop-and-Wait) or GBN(Go-Back-N)
        PacketSize = 32 % Transfered Packet Size
        PacketsCount = 10 % Number of packets
        BitTransmissionRate = 1000 % Bit transmission rate for time calculations
        ErrorRate = 0.002 % Probability of bit error value <0.0,0.5>
        SaveFilename = 'data.txt' % File to which the simulation data will be saved
        str_LastSimulationData = zeros(0) % For GUI simulation data print
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
        
        function setSaveFilename(obj,filename) % setting filename to which save data
            obj.SaveFilename = filename;
        end
        
        function [BER, OperationTime, ResendPackageCounter] = simulate(obj)
            % generowanie podzielonych pakietow i czasow przesylania
            WindowSizeGBN = 5; % !!!Placeholder value!!!
            PacketMatrix = generatePackets(obj.PacketsCount, obj.PacketSize);
            OperationTime = 0;
            ResendPackageCounter = 0;
           
            PacketMatrixBeforeCoding = PacketMatrix;
            % kodowanie + wyliczanie czasu zaleznie od metody kontroli
            % bledow
            if strcmp(obj.ErrorControlVer,'CRC32')
               PacketMatrix = kodujcrc32(PacketMatrix);
               PacketTransferTime = (obj.PacketSize+32)/obj.BitTransmissionRate; % time in seconds
            elseif strcmp(obj.ErrorControlVer,'2z5')
               PacketMatrix = koduj2z5(PacketMatrix);
               PacketTransferTime = (obj.PacketSize*5)/obj.BitTransmissionRate; % time in seconds
            elseif strcmp(obj.ErrorControlVer,'PB')
               PacketMatrix = kodujPB(PacketMatrix);
               PacketTransferTime = (obj.PacketSize+1)/obj.BitTransmissionRate; % time in seconds
            end
            TimeoutTime = PacketTransferTime * 10; % !!!Placeholder value!!!
            
            ReceivedPacketMatrix = zeros(1,obj.PacketSize*obj.PacketsCount); % for later BER calculations
            
            [,TotalSize] = size(PacketMatrix(1,:)) * obj.PacketsCount;
            ErrorCycle = floor(1 / obj.ErrorRate);
            BitsToNextError = ErrorCycle;
            if strcmp(obj.ProtocolVer,'SAW')
                % ------------STOP AND WAIT-----------
                
                for i=1:obj.PacketsCount % po kolei pakiety
                    IsReceived = false;
					          [x,y]=size(PacketMatrix);
                    infoErasure=0;              %info na temat dwójek w kanale BEC
                    for k=1:y
                      result(k)=2;              %wektor dwójek rozmiarów pakietu do BEC
                    end
                    while ~IsReceived %notReceived
                        % przesylanie
                        if strcmp(obj.ModelVer,'BSC')  
                            receivedPacket = kanalBSC(PacketMatrix(i,:), obj.ErrorRate);
                        elseif strcmp(obj.ModelVer,'BEC')
                            [receivedPacket, infoErasure] = kanalErasure(PacketMatrix(i,:), obj.ErrorRate, result); %pobranie rezultatu przes³ania i info, czy zosta³y jakieœ dwójki
                            result=receivedPacket;                         %zast¹pienie starego resulta nowym
                        elseif strcmp(obj.ModelVer, 'CEC')
                            [receivedPacket, BitsToNextError] = kanalCEC(PacketMatrix(i,:), ErrorCycle, BitsToNextError);
                        end
                        OperationTime = OperationTime + PacketTransferTime;
                        % odkodowanie/sprawdzenie
					            	if infoErasure==0                                     %jeœli nie ma dwójek-rozkodowujemy, IsReceived pozostaje falsemS
                           if strcmp(obj.ErrorControlVer,'CRC32')
                            [IsReceived, Packet] = dekodujcrc32(receivedPacket);
                           elseif strcmp(obj.ErrorControlVer,'2z5')
                            [IsReceived, Packet] = dekoduj2z5(receivedPacket);
                            elseif strcmp(obj.ErrorControlVer,'PB')
                            [IsReceived, Packet] = dekodujPB(receivedPacket);
                            end
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
                    [x,y]=size(PacketMatrix);
                    infoErasure=0;              %info na temat dwójek w kanale BEC
                    for k=1:y
                      result(k)=2;              %wektor dwójek rozmiarów pakietu do BEC
                    end
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
                             [receivedPacket, infoErasure] = kanalErasure(PacketMatrix(i,:), obj.ErrorRate, result); %pobranie rezultatu przesłania i info, czy zostały jakieś dwójki
                            result=receivedPacket;    
                        elseif strcmp(obj.ModelVer, 'CEC')
                            [receivedPacket, BitsToNextError] = kanalCEC(PacketMatrix(j,:), ErrorCycle, BitsToNextError);   
                        end
                        OperationTime = OperationTime + PacketTransferTime;
                        % odkodowanie
                        IsReceived=false;
                        if infoErasure==0
                        if strcmp(obj.ErrorControlVer,'CRC32')
                            [IsReceived, Packet] = dekodujcrc32(receivedPacket);
                        elseif strcmp(obj.ErrorControlVer,'2z5')
                            [IsReceived, Packet] = dekoduj2z5(receivedPacket);
                        elseif strcmp(obj.ErrorControlVer,'PB')
                            [IsReceived, Packet] = dekodujPB(receivedPacket);
                        end
                        else
			for p=1:obj.PacketSize
			Packet(p)=2;
			end
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
            [~, ratio] = biterr(PacketMatrixBeforeCoding, ReceivedPacketMatrix); % [ilosc bledow, procent bledow] - ilosc bledow nieuzywane
            % zapis parametrów i wyników do pliku
            % fileID = fopen(obj.SaveFilename,'a');
            % format = '%s;%s;%s;%d;%d;%d;%f;%f;%f;%d\n';
            % fprintf(fileID, format, obj.ModelVer, obj.ErrorControlVer,obj.ProtocolVer, obj.PacketSize, obj.PacketsCount, obj.BitTransmissionRate, obj.ErrorRate, ratio, OperationTime, ResendPackageCounter);
            % fclose(fileID);
            % zapis parametrów i wyników do stringu
            format = '%s;%s;%s;%d;%d;%d;%.3f;%.3f;%.3f;%d\n';
            obj.str_LastSimulationData = sprintf(format, obj.ModelVer, obj.ErrorControlVer,obj.ProtocolVer, obj.PacketSize, obj.PacketsCount, obj.BitTransmissionRate, obj.ErrorRate, ratio, OperationTime, ResendPackageCounter);
            BER = ratio;
        end
    end
    
end

