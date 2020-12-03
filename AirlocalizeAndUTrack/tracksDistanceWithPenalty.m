function [ distance ] = tracksDistanceWithPenalty( trackedFeatInfo1, trackedFeatInfo2,...
    atmat )
%trackDistance: Calculate the distance between two tracks
%  If one track is missing some time points, there is a penalty associated 
%  with it: the nonoverlapping time point is set to the mean distance
%   Detailed explanation goes here
%   Calculate the deviation between two tracks, typically two color of the
%   same particles
%   SUM((x1(i)-x2(i))^2+(y1(i)-y2(i))^2,i)
%   Assume there is no merge and split
% atmat: the affine transformatio matirx
if nargin < 3 
    atmat = [1 0 0 0];
end
maxDistance=100;
startTime1=trackedFeatInfo1.seqOfEvents(1,1);
endTime1=trackedFeatInfo1.seqOfEvents(end,1);

startTime2=trackedFeatInfo2.seqOfEvents(1,1);
endTime2=trackedFeatInfo2.seqOfEvents(end,1);

if min(endTime1, endTime2)-max([startTime1 startTime2]) < 5
    distance=maxDistance;
    return
end
startTime=min([startTime1 startTime2]);
endTime=max([endTime1 endTime2]);
nT=endTime-startTime+1;

tracksX1=NaN(nT,1);
tracksY1=NaN(nT,1);
indxFinal1=(startTime1-startTime+1):(endTime1-startTime+1);
%indx=1:8:8*(endTime1-startTime1+1)+1;
tracksX1(indxFinal1)=trackedFeatInfo1.tracksCoordAmpCG(1,1:8:end);
tracksY1(indxFinal1)=trackedFeatInfo1.tracksCoordAmpCG(1,2:8:end);

tracksX2=NaN(nT,1);
tracksY2=NaN(nT,1);
indxFinal2=(startTime2-startTime+1):(endTime2-startTime+1);
%indx=1:8:8*(endTime2-startTime2+1)+1;
tracksX2(indxFinal2)=trackedFeatInfo2.tracksCoordAmpCG(1,1:8:end);
tracksY2(indxFinal2)=trackedFeatInfo2.tracksCoordAmpCG(1,2:8:end);
xy2=affineTransformXY(atmat, [tracksX2(:) tracksY2(:)],1);

dfx2=(tracksX1(:)-xy2(:,1)).^2;
dfy2=(tracksY1(:)-xy2(:,2)).^2;
mnx2=nanmean(dfx2);
mny2=nanmean(dfy2);
indNan=find(isnan(dfx2));
dfx2(indNan)=mnx2;
dfy2(indNan)=mny2;
distance=mean(sqrt(dfx2+dfy2));

% obsAvail=intersect(obsAvail1, obsAvail2);
% nobs=length(obsAvail);
% distance=sum(sqrt((tracksX2(obsAvail)-tracksX1(obsAvail)+offset(1)).^2+...
%     (tracksY2(obsAvail)-tracksY1(obsAvail)+offset(2)).^2))/nobs;  
end

