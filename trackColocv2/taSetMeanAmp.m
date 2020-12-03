function [taStr]=taSetMeanAmp(taStr, mode, avg)
%Obj:
%   set the track mean intensity. If avg is given, set to avg, otherwise, 
%   set to the mean intensity of all tracks
%Input
%   taStr: track analysis strcture, {amp, avg, ac, acw}
%   mode: how to calculate the mean value
%   avg: the mean intensity to be assigned to avg in the taStr
%Output
%   taStr
%Version
%   Bin Wu: 08/22/2018

n=length(taStr);
if n<1
    taStr=[];
    return;
end
if nargin<2 
    mode =0;
end
if mode == 0    %default set to the global mean of all trace
    avg=mean(horzcat(taStr.amp));   %assuming amp is 1xn;
    for i=1:n
        taStr(i).avg=avg;
    end
elseif mode ==1 %set to the mean of each trace
    for i=1:n
        taStr(i).avg=nanmean(taStr(i).amp);
    end
elseif mode == 2    %set to a set value
    if nargin>=3
        for i=1:n
            taStr(i).avg=avg;
        end
    end
else
    disp('taSetMeanAmp: incorrect mode');
    return
end
end