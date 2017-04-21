classdef Simulation < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ModelVer = 'BSC' % BSC(Binary Symetric Channel)
        ErrorControlVer = 'CRC32' % CRC32(Cyclic Redundancy Check) or 2z5(kod 2 z 5)
        ProtocolVer = 'SAN' % SAN(Stop-and-Wait) or GBN(Go-Back-N)
        PacketSize = 32 % Transfered Packet Size
        BitTransmissionRate = 1000
        ErrorRate = 5
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
        
        function simulate(obj)
            % generowanie
            X1 = generate(lenght, obj.PacketSize);
            % podzial na pakiety
            X2 = packets(X1, obj.PacketSize);
            % kodowanie
            koduj2z5(X2);
            kodujcrc32(X2);
            % ------------STOP AND WAIT-----------
            for % po kolei pakiety
                while(notReceived)
                    % przesylanie
                    kanalBSC();
                    kanalErasure(); % albo gilbert
                    % odkodowanie/sprawdzenie
                    dekoduj2z5();
                    dekodujcrc32();
                end
                % dodajemy pakiet do wynik
            end
            % -------------------------
            % -------------GO BACK N------------
            for % po kolei pakiety
                
                while(notReceived)
                    
                    % przesylanie
                    kanalBSC();
                    kanalErasure(); % albo gilbert
                    % odkodowanie/sprawdzenie
                    dekoduj2z5();
                    dekodujcrc32();
                end
                % dodajemy pakiet do wynik
            end
            % -------------------------
            % porównanie
        end
    end
    
end

