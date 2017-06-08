AverageBER = 0;
AverageOT = 0;
AverageRPC = 0;
NumberOfSimulations = 1000;

startErrorRate = 0.0000;

for j = 1:50

    startErrorRate = startErrorRate + 0.0002;
    
for i = 1:NumberOfSimulations
    
    x = Simulation();
    x.setModelVer('BEC') % BSC, BEC, CEC
    x.setErrorControlVer('2z5') % CRC32, 2z5, PB
    x.setProtocolVer('GBN') % SAW , GBN
    x.setPacketSize(8) % 8/16/64/256/512
    x.setPacketsCount(10) % 10
    x.setBitTransRate(1000) % raczej nie zmieniac
    x.setErrorRate(startErrorRate) % 0 - 0.5
    
    [BER, OT, RPC] = x.simulate();
    
    AverageBER = AverageBER + BER;
    AverageOT = AverageOT + OT;
    AverageRPC = AverageRPC + RPC;
end
    
AverageBER = AverageBER/NumberOfSimulations;
AverageOT = AverageOT/NumberOfSimulations;
AverageRPC = AverageRPC/NumberOfSimulations;

fileID = fopen('data_skrypt.txt','a');
format = '%s;%s;%s;%d;%d;%d;%f;%f;%f;%f\n';
fprintf(fileID, format, x.ModelVer, x.ErrorControlVer, x.ProtocolVer, x.PacketSize, x.PacketsCount, x.BitTransmissionRate, x.ErrorRate, AverageBER, AverageOT, AverageRPC);
fclose(fileID);
AverageBER
end