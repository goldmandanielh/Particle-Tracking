function [tracks2Sorted, ind]=tracksSortByOverlapTime(track1, tracks2)
%Obj: Given a single track 1, tracks2 are a set of candidate tracks that colocalize with
%it. Sort the tracks according to the overlap time with track 1. 

sel1=getTrackSEL(track1);
sels2=getTrackSEL(tracks2);
n2=length(tracks2);
overlapTime=min([sels2(:,2), zeros(n2,1)+sel1(2)],[],2)-max([sels2(:,1),zeros(n2,1)+sel1(1)],[],2);  %endTime-startTime
[~,ind]=sort(overlapTime,'descend');
tracks2Sorted=tracks2(ind);
end