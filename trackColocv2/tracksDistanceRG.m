function [distance, overlapTime]=tracksDistanceRG(trackedFeatInfo1, trackedFeatInfo2,  imageGap, minTimeOverlap, maxDistance, transformPara)
%Objective:
%   calculate the distance between two tracks
%   If one track is missing some time points, there is a penalty associated
%   with it: the nonoverlapping time point is set to the mean distance
%   Assume there is no merge and split
%Note: in case green channel imaged more frequently than red, use the green
%   channel index as the time. 

%Input Para:
%   trackedFeatInfo1: track 1, typically Red
%   trackedFeatInfo2: track 2, typically Green
%   imageGap: green imaged more frequently than red. 
%   minTimeOverlap: minimum overlap in time between two track to consider
%   maxDistance: the maximum distance assigned to
%   transformPara: The transformation matrix obtained from the calibration
%Output Para
%   distance: distance between two tracks
%   overlapTime: overlapped time points, which both tracks exist
%History: 
%   BW: July 14, 2018   

if nargin < 3 
    imageGap=1;
end
if nargin < 4 
    minTimeOverlap=3;
end
if nargin < 5 
    maxDistance=100;    %in pixels
end
if nargin < 6 
    transformPara = [0 0 0 0 0 0];
end

%calculate the overlaped indx and positions in the common time frame
[overlapIndx, pos1, pos2]=trackOverlapTimePos(trackedFeatInfo1, trackedFeatInfo2, imageGap);

if length(overlapIndx) < minTimeOverlap
    distance=maxDistance;
    return
end

pos2Trans=transformXY(transformPara, pos2); %correction of chromatic abberation
dist=sqrt(sum((pos1-pos2Trans).^2,2));  %distance at each time point
md=nanmean(dist);   %average distance for overlapped time points
indNan=find(isnan(dist));
dist(indNan)=md;  %set the non-overlapping time points to the average distance along the track
distance=mean(dist);    %the distance between tracks is defined as the mean distance
overlapTime=length(overlapIndx);    %The indices both tracks exists
end
