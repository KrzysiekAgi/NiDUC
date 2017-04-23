function [ codedData ] = kodujcrc32( data )
%KODUJCRC32 Summary of this function goes here
%   w gen tworzê generator CRC z wielomianem takim jak w nawiasach
%   kwadratowych (znalaz³em ¿e taki jest dla 32b), tworz¹cy dwie
%   "subframes". Tê iloœæ zmieniamy ostatnim argumentem. F-cja step tworzy
%   zakodowany ci¹g i dodaje go do wektora data. Do detekcji mo¿na u¿yæ
%   obiektu comm.CRCDetector
%   Jeœli ktoœ ma lepszy pomys³, to zmieniajcie ten kod :P 
gen = comm.CRCGenerator([1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 1 0 0 0 1 1 1 0 1 1 0 1 1 0 1 1 1],'ChecksumsPerFrame',2);
codedData = step(gen, data);

end

