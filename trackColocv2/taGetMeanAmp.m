function avg=taGetMeanAmp(taStr)
%Obj: calculate the mean intensity from an analysis strcuture array
if length(taStr)<1
    avg=[];
    disp('taGetMeanAmp: empty taStr');
    return;
else
    avg=mean(horzcat(taStr.amp));
end
end