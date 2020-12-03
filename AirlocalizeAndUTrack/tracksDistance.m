function [ distance ] = tracksDistance( trackedFeatInfo1, trackedFeatInfo2,...
    offset )
%trackDistance: Calculate the distance between two tracks
%   Detailed explanation goes here
%   Calculate the deviation between two tracks, typically two color of the
%   same particles
%   SUM((x1(i)-x2(i))^2+(y1(i)-y2(i))^2,i)
%   Assume there is no merge and split
if nargin < 3 
    offset = [0 0];
end
maxDistance=100;
startTime1=trackedFeatInfo1.seqOfEvents(1,1);
endTime1=trackedFeatInfo1.seqOfEvents(end,1);

startTime2=trackedFeatInfo2.seqOfEvents(1,1);
endTime2=trackedFeatInfo2.seqOfEvents(end,1);

startTime=max([startTime1 startTime2]);
endTime=min(endTime1, endTime2);
if endTime-startTime < 5
    distance=maxDistance;
    return
end

indx=8*(startTime-startTime1)+1:8:8*(endTime-startTime1)+1;
tracksX1=trackedFeatInfo1.tracksCoordAmpCG(1,indx);
tracksY1=trackedFeatInfo1.tracksCoordAmpCG(1,indx+1);
obsAvail1=find(~isnan(tracksX1));

indx=8*(startTime-startTime2)+1:8:8*(endTime-startTime2)+1;
tracksX2=trackedFeatInfo2.tracksCoordAmpCG(1,indx);
tracksY2=trackedFeatInfo2.tracksCoordAmpCG(1,indx+1);
obsAvail2=find(~isnan(tracksX2));

obsAvail=intersect(obsAvail1, obsAvail2);
nobs=length(obsAvail);
distance=sum(sqrt((tracksX2(obsAvail)-tracksX1(obsAvail)+offset(1)).^2+...
    (tracksY2(obsAvail)-tracksY1(obsAvail)+offset(2)).^2))/nobs;  
end

