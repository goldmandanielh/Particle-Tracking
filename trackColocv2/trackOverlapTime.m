function overlapTimePoints=trackOverlapTime(track1, track2, imageGap)
%Obj: calculate the overlap time between two tracks
%
%Input
%   track1, track2: two tracks in different channel
%   imageGap, if > 0, track1 image less frequently than track2
%             if <0, track1 image more freqently than track2
startTime1=track1.seqOfEvents(1,1);
endTime1=track1.seqOfEvents(end,1);
startTime2=track2.seqOfEvents(1,1);
endTime2=track2.seqOfEvents(end,1);
if imageGap>0
    startTime1Trans=(startTime1-1)*imageGap+1;   %Considering the different interval
    endTime1Trans=(endTime1-1)*imageGap+1;
    startTime2Trans=startTime2;
    endTime2Trans=endTime2;
else
    startTime1Trans=startTime1;
    endTime1Trans=endTime1;
    startTime2Trans=(startTime2-1)*(-imageGap)+1;   %Considering the different interval
    endTime2Trans=(endTime2-1)*(-imageGap)+1;
end
startTime=min([startTime1Trans startTime2Trans]);
endTime=max([endTime1Trans endTime2Trans]);
nT=endTime-startTime+1;      %
tracksX1=NaN(nT,1);
tracksX2=NaN(nT,1);
if imageGap>0
    indxFinal1=(startTime1Trans-startTime+1):imageGap:(endTime1Trans-startTime+1);
    tracksX1(indxFinal1)=track1.tracksCoordAmpCG(1,1:8:end);    %This takes into account the missing points
    indxFinal2=(startTime2-startTime+1):(endTime2-startTime+1);
    tracksX2(indxFinal2)=track2.tracksCoordAmpCG(1,1:8:end);
else
    indxFinal1=(startTime1Trans-startTime+1):(endTime1Trans-startTime+1);
    tracksX1(indxFinal1)=track1.tracksCoordAmpCG(1,1:8:end);    %This takes into account the missing points
    indxFinal2=(startTime2-startTime+1):(-imageGap):(endTime2-startTime+1);
    tracksX2(indxFinal2)=track2.tracksCoordAmpCG(1,1:8:end);
end
overlapTimePoints=find((~isnan(tracksX1)) & (~isnan(tracksX2)));
end

