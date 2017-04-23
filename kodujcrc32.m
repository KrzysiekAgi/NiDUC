function [ codedData ] = kodujcrc32( data )
%KODUJCRC32 Summary of this function goes here
%   w gen tworz� generator CRC z wielomianem takim jak w nawiasach
%   kwadratowych (znalaz�em �e taki jest dla 32b), tworz�cy dwie
%   "subframes". T� ilo�� zmieniamy ostatnim argumentem. F-cja step tworzy
%   zakodowany ci�g i dodaje go do wektora data. Do detekcji mo�na u�y�
%   obiektu comm.CRCDetector
%   Je�li kto� ma lepszy pomys�, to zmieniajcie ten kod :P 
gen = comm.CRCGenerator([1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1],'ChecksumsPerFrame',2);
codedData = step(gen, data);

end

