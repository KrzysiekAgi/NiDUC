function [ corruptedData ] = kanalCEC( data, p )
%UNTITLED Summary of this function goes here
%   channel with cyclic errors
[m,n]=size(data);
corruptedNumber=round(n*p);
<<<<<<< HEAD
if corruptedNumber ~= 0
=======
if corruptedNumber~=0
>>>>>>> 25f61c93f1c6e8e8d264bd1d7813fc486e710a79
corruptedSpace=round(n/corruptedNumber);
else 
corruptedSpace=n+1;
end
for i=1:n
  if mod(i,corruptedSpace)==0
    corruptedData(i)=xor(data(i),1);
    i=i+1;
      else
      corruptedData(i)=data(i);
      i=i+1;
    end
    end
end

