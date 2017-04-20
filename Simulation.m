classdef Simulation < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ModelVer = 'BSC' % BSC(Binary Symetric Channel)
        ErrorControlVer = 'CRC32' % CRC32(Cyclic Redundancy Check) or 2z5(kod 2 z 5)
        ProtocolVer = 'SAN' % SAN(Stop-and-Wait) or GBN(Go-Back-N)
        PacketSize = 32 % Transfered Packet Size
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
        end
    end
    
end

