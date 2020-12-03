function [overlapIndx, pos1, pos2, sel, indx1, indx2, amp1, amp2]=trackOverlapTimePos(track1, track2,  imageGap)
%Obj:
%   Given 2 tracks, find the overlapped Time point and positions in the
%   common time frame
%Input para
%   track1, track2: the two tracks, usually trackR and trackG
%   imageGap: in case the two channel acquired at different interval,
%             imageGap is the ratio between the image intervals
%             When track2 more frequent than track1, imageGap>0
%             When track1 more frequent than track1, imageGap<0
%Output
%   OverlapIndx: the overlap indx in the overall time frame
%   pos1: [x,y] positions of the track1 in the combined time frame
%   pos2: [x,y] positions of the track2 in the combined time frame
%   sel: [start, end, length] of the combined time frame
%History: 
%   BW: July 14, 2018   
%

if nargin<3
    imageGap=1;
end

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
if endTime1Trans < startTime2Trans || endTime2Trans < startTime1Trans %The two tracks do not overlap in time
    overlapIndx=[];
    sel=[];
    indx1=[];
    indx2=[];
    pos1=[];
    pos2=[];
    return;
end
startTime=min([startTime1Trans startTime2Trans]);
endTime=max([endTime1Trans endTime2Trans]);
nT=endTime-startTime+1;      %
sel=[startTime, endTime, nT];
if imageGap>0
    indx1=(startTime1Trans-startTime+1):imageGap:(endTime1Trans-startTime+1);
    indx2=(startTime2Trans-startTime+1):(endTime2Trans-startTime+1);
else
    indx1=(startTime1Trans-startTime+1):(endTime1Trans-startTime+1);
    indx2=(startTime2Trans-startTime+1):(-imageGap):(endTime2Trans-startTime+1);
end
x1=NaN(nT,1);y1=NaN(nT,1);
x2=NaN(nT,1);y2=NaN(nT,1);
amp1=NaN(nT,1); amp2=NaN(nT,1);

x1(indx1)=track1.tracksCoordAmpCG(1,1:8:end);
y1(indx1)=track1.tracksCoordAmpCG(1,2:8:end);
amp1(indx1)=track1.tracksCoordAmpCG(1,4:8:end);
x2(indx2)=track2.tracksCoordAmpCG(1,1:8:end);
y2(indx2)=track2.tracksCoordAmpCG(1,2:8:end);
amp2(indx2)=track2.tracksCoordAmpCG(1,4:8:end);
indx1=find(~isnan(x1));
indx2=find(~isnan(x2));
overlapIndx=find((~isnan(x1)) & (~isnan(x2)));
pos1=[x1 y1];
pos2=[x2 y2];
end
